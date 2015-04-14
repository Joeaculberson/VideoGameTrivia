class OrdersController < ApplicationController
  def express_checkout
    session[:coin_amount] = params[:coin_amount].to_i
    response = EXPRESS_GATEWAY.setup_purchase(params[:payment_amount].to_i,
                                              :ip                => request.remote_ip,
                                              :return_url        => new_order_url,
                                              :cancel_return_url => orders_url
    )
    p response
    p response.token
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    @order = Order.new(:express_token => params[:token])
    current_user.coins += session[:coin_amount]
    current_user.save!
    flash[:success] = 'Thank you for your purchase. ' + session[:coin_amount].to_s + ' coins have been added to your account for a total of ' + current_user.coins.to_s + '.'
    redirect_to coin_store_path
  end

  def show
    redirect_to games_path
  end

  def create
    @order = @cart.build_order(order_params)
    @order.ip = request.remote_ip

    if @order.save
      if @order.purchase # this is where we purchase the order. refer to the model method below
        redirect_to order_url(@order)
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end
end
