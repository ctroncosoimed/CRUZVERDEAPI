class V1::DigitalizacionController < ApplicationController

  def self.digitalizacion(params)

    return render json: {error: "La descripcion del documento debe ser completada", status: 400} if params[:TipoDoc] == 'txt' and params[:TextoDoc] == ""
    return render json: {error: "Institución es obligatoria", status:400} unless params[:Institucion].present?
    return render json: {error: "TipoDoc es obligatorio", status:400} unless params[:TipoDoc].present?
    return render json: {error: "DescripcionDocumento es obligatorio", status:400} unless params[:DescripcionDocumento].present?
    return render json: {error: "File_mime es obligatorio", status:400} unless params[:File_mime].present?
    return render json: {error: "File es obligatorio", status:400} unless params[:File].present?
    return render json: {error: "Firmantes es obligatorio", status:400} unless params[:Firmantes].present?

    @result= save_document(params)

    @response=
      if @result[:status] == true
        {CodError: 0,
         Mensaje: 0,
         CodigoDEC: "#{@result[:codigo_dec]}"}
      else
        @result= {error: "Revisar Parametros Obligatorios", status: 400}
      end
    render json: @response
  end

end