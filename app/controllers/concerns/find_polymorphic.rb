module FindPolymorphic
  def find_polymorphic(params)
    classes = []
    params.each do |name, value|
      classes << $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    classes.last || nil
  end
end
