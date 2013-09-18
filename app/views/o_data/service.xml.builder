xml.instruct!
xml.tag!(:service, "xmlns:atom" => "http://www.w3.org/2005/Atom", "xmlns" => "http://www.w3.org/2007/app", "xml:base" => o_data_engine.service_url) do
  ODataController.data_services.schemas.each do |schema|
	  xml.tag!(:workspace) do
	    xml.atom(:title, schema.namespace)
	    schema.entity_types.collect(&:plural_name).sort.each do |plural_name|
	      xml.tag!(:collection, :href => plural_name) do
	        xml.atom(:title, plural_name)
	      end
	    end
	  end
  end
end
