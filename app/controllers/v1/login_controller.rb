class V1::LoginController < ApplicationController
  before_action :user_validate

  def token
    render json: {token: "Ab91572Ixtkh9n", status: 201}
  end  

  private

  def user_validate
    return render json: {mensaje: "Debe ingresar usuario o contraseña", status: 400} unless params[:user].present? and params[:password].present?
    return render json: {mensaje: "Usuario o Contraseña Invalido", status: 400} unless params[:user] == 'CRUZVERDE' and params[:password] == 'CRUZVERDE2018'
  end

end