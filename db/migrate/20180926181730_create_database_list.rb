class CreateDatabaseList < ActiveRecord::Migration[5.2]
  def change
    create_table :container_list_document do |t|
      t.string :dec_code #Codigo Dec Que se utilizara
      t.string :id_code #ID del codigo a utilizar (Voucher....)
      t.string :type_code #Tipo de a utilizar (Voucher....)
      t.string :institution #Institucion entregada por el usuario
      t.string :mime_type #Tipo de documento que entrega el usuario(pdf/xml/txt)
      t.string :description #Descripción del documento entregado por el usuario
      t.string :place_code #Siglas del pais en mayuscula entregadas por el usuario
      t.text :file #Archivo en base64 entregado por el usuario
      t.json :signatories #Firmantes entregados por el usuario
      t.json :tags #Tags entregados por el usuario
      t.boolean :busy #Campo para saber si el documento esta utilizado o no.
      t.json :related_document #Json con los datos del documento relacionado
      t.integer :status #Se cargarar un status en caso de que no se pueda guardar el archivo
      t.string :mesaje_status #Se guardara el mensaje en caso de que el dec responda que no se puede guardar
      t.timestamps
    end
  end
end
