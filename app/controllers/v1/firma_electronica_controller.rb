class V1::FirmaElectronicaController < ApplicationController
  before_action :token_validate
  before_action :audit_validate
  before_action :roles_validate


  def index
    if params[:accion].present?
      @result= case params[:accion].downcase
               when "firma" then V1::FirmaController.firma(params)
               when "digitalizacion" then V1::DigitalizacionController.digitalizacion(params)
               else {error: "Ingrese Acciones Validas", status:400}
               end
    else
      @result= {error: "Parametro Accion Obligatorio", status: 400}
    end
    render json: @result
  end

end