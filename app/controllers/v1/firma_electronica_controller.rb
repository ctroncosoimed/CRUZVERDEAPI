class V1::FirmaElectronicaController < ApplicationController
  before_action :token_validate
  before_action :audit_validate

  def index
    if params[:accion].present?
      @result= case params[:accion].downcase
               when "firma" then V1::FirmaController.firma(params)
               when "digitalizacion" then V1::DigitalizacionController.digitalizacion(params)
               else {CodError:1, mensaje: "Ingrese Acciones Validas", status:400}
               end
    else
      @result= {CodError:1, mensaje: "Parametro Accion Obligatorio", status: 400}
    end
    render json: @result
  end

end