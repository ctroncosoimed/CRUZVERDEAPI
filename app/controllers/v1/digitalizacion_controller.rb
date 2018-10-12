class V1::DigitalizacionController < ApplicationController

  def self.digitalizacion(params)

    return render json: {CodError:1, mensaje: "La descripcion del documento debe ser completada", status: 400} if params[:TipoDoc] == 'txt' and params[:TextoDoc] == ""
    return render json: {CodError:1, mensaje: "Institución es obligatoria", status: 400} unless params[:Institucion].present?
    return render json: {CodError:1, mensaje: "TipoDoc es obligatorio", status: 400} unless params[:TipoDoc].present?
    return render json: {CodError:1, mensaje: "DescripcionDocumento es obligatorio", status: 400} unless params[:DescripcionDocumento].present?
    return render json: {CodError:1, mensaje: "File_mime es obligatorio", status: 400} unless params[:File_mime].present?
    return render json: {CodError:1, mensaje: "File es obligatorio", status: 400} unless params[:File].present?
    return render json: {CodError:1, mensaje: "Firmantes es obligatorio", status: 400} unless params[:Firmantes].present?

    @result= save_document(params)

    @response=
      if @result[:status] == true
        {CodError: 0,
         Mensaje: 0,
         CodigoDEC: "#{@result[:codigo_dec]}"}
      else
        @result= {CodError:1, Mensaje:"Revisar Parametros Obligatorios"}
      end
    render json: @response
  end

end