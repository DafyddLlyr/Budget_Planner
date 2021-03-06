require("sinatra")
require("sinatra/contrib/all")
require_relative("../models/transaction")
require_relative("../models/user")
require_relative("../models/merchant")
require_relative("../models/category")
also_reload('../models/*')

get "/users/:user_id/transactions" do
  @user = User.find(params["user_id"])
  @transactions = @user.transactions()
  erb(:"users/transactions/index")
end

get "/users/:user_id/transactions/new" do
  @user = User.find(params["user_id"].to_i)
  @merchants = Merchant.all().sort_by { |merchant| merchant.name }
  @categories = Category.all().sort_by { |category| category.name }
  erb(:"users/transactions/new")
end

post "/users/:user_id/transactions" do
  @transaction = Transaction.new(params)
  @user = User.find(params["user_id"].to_i)

  @transaction.value = (params["pounds"].to_i * 100) + params["pence"].to_i
  @transaction.save()

  @saving_amount = (100 - params["pence"].to_i)

  if @saving_amount != 100 && params["save"] == "on"
    @user.savings += @saving_amount
  end

  @user.spent += @transaction.value
  @user.update()

  erb(:"/users/transactions/created")
end

get "/users/:user_id/transactions/:id" do
  @user = User.find(params["user_id"].to_i)
  @transaction = Transaction.find(params["id"])
  erb(:"users/transactions/show")
end

post "/users/:user_id/transactions/:id/delete" do
  @transaction = Transaction.find(params["id"])
  @user = User.find(params["user_id"].to_i)
  @user.spent -= @transaction.value if @user.spent > 0
  @user.update()
  @transaction.delete()
  erb(:"users/transactions/deleted")
end

get "/users/:user_id/transactions/:id/edit" do
  @user = User.find(params["user_id"].to_i)
  @merchants = Merchant.all().sort_by { |merchant| merchant.name }
  @categories = Category.all().sort_by { |category| category.name }
  @transaction = Transaction.find(params["id"])
  erb(:"users/transactions/edit")
end

post "/users/:user_id/transactions/:id" do
  @updated_transaction = Transaction.new(params)
  new_value = (params["pounds"].to_i * 100) + params["pence"].to_i
  old_value = Transaction.find(params["id"]).value
  difference = new_value - old_value
  @updated_transaction.value = new_value
  @updated_transaction.update()
  @user = User.find(params["user_id"].to_i)
  @user.spent += difference
  @user.update()
  erb(:"users/transactions/updated")
end
