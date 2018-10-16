class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(data)
    hash = data.is_a?(String) ? JSON.parse(data) : data
    (hash || {}).with_indifferent_access
  end
end
