class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(data)
    hash = data.is_a?(String) ? JSON.parse(data) : data
    return hash if hash.is_a?(Array)

    (hash || {}).with_indifferent_access
  end
end
