class ApplicationController < ActionController::API

  def token_validate
    return render json: {error: "Token Invalido", status: 400} unless params[:auth_token].present? and params[:auth_token] == 'Ab91572Ixtkh9n'
  end

  def audit_validate
    if params[:accion].downcase == 'firma'
      @auditoria = []
      params[:Firmantes].map { |x| @auditoria << x["Auditoria"] if x["Auditoria"].present? }
      return render json: {error: "Debe haber almenos 1 auditoria", status: 400} unless @auditoria.present?
      request= 
        Typhoeus.post("http://200.0.156.150/cgi-bin/autentia-audit.cgi",
          body:"
            <soapenv:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:urn='urn:wsaudit'>
               <soapenv:Header/>
               <soapenv:Body>
                  <urn:wsaudit soapenv:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'>
                     <WSAuditReadReq xsi:type='urn:CAuditReadReq'>
                        <wsUsuario xsi:type='xsd:string'>Autentia</wsUsuario>
                        <wsClave xsi:type='xsd:string'>@ut3nti4.</wsClave>
                        <NroAudit xsi:type='xsd:string'>#{@auditoria.join}</NroAudit>
                        <bWsq>true</bWsq>
                        <bBmp>false</bBmp>
                     </WSAuditReadReq>
                  </urn:wsaudit>
               </soapenv:Body>
            </soapenv:Envelope>
          ",
          headers:{Accept: "application/xml"})
    result= Hash.from_xml(request.body)
    return render json: {error: "#{result["Envelope"]["Body"]["WSAuditReadResp"]["Resultado"]["Glosa"]}", status: 400} if result["Envelope"]["Body"]["WSAuditReadResp"]["Resultado"]["Err"].to_i == 5000
    return render json: {error: "Auditoria NO valida para CRUZVERDE", status: 400} if result["Envelope"]["Body"]["WSAuditReadResp"]["DatosSistema"]["Institucion"] != 'CRUZVERDE' 
    end
  end

  def self.save_document(params)
    if params[:accion].downcase == 'firma'
      document = TableService.where(busy: false, id_code: params[:TipoDoc]).last
      if document.present?
        update= document.update_attributes(institution: params[:Institucion],
                                           mime_type: params[:TipoDoc],
                                           description: params[:DescripcionDocumento],
                                           place_code: params[:File_mime],
                                           file: params[:File],
                                           signatories: params[:Firmantes],
                                           tags: params[:Tags],
                                           busy: true)

        response= update ? {status:true, codigo_dec: document.dec_code} : {status:false}
      else
        response= {status: false}
      end
    elsif params[:accion].downcase == 'digitalizacion'
      document = TableService.where(busy: false, id_code: params[:TipoDoc]).last
      if document.present?
        update= document.update_attributes(institution: params[:Institucion],
                                           mime_type: params[:TipoDoc],
                                           description: params[:DescripcionDocumento],
                                           place_code: params[:File_mime],
                                           file: params[:File],
                                           tags: params[:Tags],
                                           related_document: params[:DocRelacionados],
                                           busy: true)

        response= update ? {status:true, codigo_dec: document.dec_code} : {status:false}
      else
        response= {status: false}
      end
    end
    response
  end

  def error404
    return render json: {mensaje: "ruta no encontrada", status: 400}
  end

end