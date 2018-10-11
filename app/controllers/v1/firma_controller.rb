class V1::FirmaController < ApplicationController

  def self.firma(params)
    return render json: {error: "La descripcion del documento debe ser completada", status: 400} if params[:TipoDoc] == 'txt' and params[:TextoDoc] == ""
    return render json: {error: "Institución es obligatoria", status:400} unless params[:Institucion].present?
    return render json: {error: "TipoDoc es obligatorio", status:400} unless params[:TipoDoc].present?
    return render json: {error: "DescripcionDocumento es obligatorio", status:400} unless params[:DescripcionDocumento].present?
    return render json: {error: "File_mime es obligatorio", status:400} unless params[:File_mime].present?
    return render json: {error: "File es obligatorio", status:400} unless params[:File].present?
    return render json: {error: "Firmantes es obligatorio", status:400} unless params[:Firmantes].present?

    @result= save_document(params)
    @firmantes= []
    @auditoria= []

    params[:Firmantes].map do |x|
      if x["Auditoria"].present?
        @firmantes << x["Rut"]
        @auditoria << x["Auditoria"]
      end
    end

    @response =
      if  @result[:status] == true
         {CodError: 0,
          Mensaje: "OK",
          CodigoDEC: "#{@result[:codigo_dec]}",
          LadrilloDeFirma: "Este documento es una representación de un documento original en formato electrónico. Para verificar el estado actual del documento verificarlo en 5cap.dec.cl Firmante: #{@firmantes.join}, Institución: #{params[:Institucion]}, Fecha de Firma: #{DateTime.now.strftime("%d/%m/%Y")}, Auditoria: #{@auditoria.join}, Operador: 1-9",
          status: 201}
      else
        {Mensaje:"Vuelva a intentarlo mas tarde" , status: 400}
      end
    render json: @response
  end
end