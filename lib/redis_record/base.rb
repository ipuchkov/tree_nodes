class RedisRecord::Base
  include RedisRecord::Errors
  include RedisRecord::RecordColumns

  attr_reader :attributes

  record_columns primary_key: 'id', fields: []

  def initialize(attributes = {})
    initialize_attributes
    set_attributes(attributes)
  end

  def save
    save_data
  end

  def save!
    raise RecordNotSaved.new("Can`t save record: #{self}") unless save_data
  end

  def method_missing(m, *args, &block)
    m_sym = m.to_s.gsub(/\=$/, '').to_sym
    if self.class.attributes.include?(m_sym)
      if m.match(/\=$/)
        @attributes[m_sym] = args.first
      else
        @attributes[m_sym]
      end
    else
      super
    end
  end

  def obj_primary_key
    self.attributes[self.class.primary_key]
  end

  def ==(comparison_object)
    super ||
      comparison_object.instance_of?(self.class) &&
      !obj_primary_key.nil? &&
      comparison_object.obj_primary_key == obj_primary_key
  end
  alias :eql? :==

  private

  def save_data
    check_primary_key
    set_created_at
    set_data
  end

  def set_created_at
    unless self.created_at.present?
      self.created_at = Time.zone.now.to_s
    end
  end

  def set_data
    all_attributes = attributes
    primary_key = all_attributes.delete(self.class.primary_key)
    if RedisConnector::Redis.instance.set(self.class.namespace, primary_key, all_attributes.to_a.flatten) == 'OK'
      self.class.find(primary_key)
    else
      false
    end
  end

  def check_primary_key
    primary_key = self.class.primary_key
    if attributes[primary_key].nil?
      attributes[primary_key] = SecureRandom.hex(25)
    end
  end

  def initialize_attributes
    @attributes = {}
    self.class.attributes.each do |attribute|
      @attributes.merge!(attribute => nil)
    end
  end

  def set_attributes(data_attributes)
    data_attributes.each do |attribute, value|
      raise RedisRecord::Errors::WrongAttribute.new("unknown attribute '#{attribute}' for #{self.class.name}") unless self.class.attributes.include?(attribute.to_sym)
      @attributes[attribute.to_sym] = value
    end
  end

  class << self
    def find(id)
      if (data = get_record(id)).present?
        new(data.merge(primary_key => id))
      else
        nil
      end
    end

    def find_by(field, value)
      unless self.attributes.include?(field)
        raise RedisRecord::Errors::WrongAttribute.new("Attribute #{field} does not exist")
      end
      self.all.select { |r| r.send(field) == value.to_s }.first
    end

    def all
      @records = []
      instantiate_data

      @records
    end

    def include?(obj)
      records_list.select {|r| r.split(/\:/).last == obj.obj_primary_key}.any?
    end

    def destroy_all
      records_list.map {|r| RedisConnector::Redis.instance.del(r)}
    end

    def namespace
      @namespace ||= self.name.underscore
    end

    private

    def get_record(id)
      RedisConnector::Redis.instance.get_all(namespace, id)
    end

    def instantiate_data
      records_list.each do |record|
        record_id = record.gsub(/\A#{namespace}:/, '')
        @records << find(record_id)
      end
    end

    def records_list
      RedisConnector::Redis.instance.keys(namespace)
    end
  end
end
