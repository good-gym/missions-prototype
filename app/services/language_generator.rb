require "yaml"

# Language generator
class LanguageGenerator
  def self.data
    @data ||= YAML.load(File.read("config/language_generator.yml"))
  end

  def self.encouragement(name, seed = nil)
    new(:encouragement, seed).to_s.sub("$NAME", name)
  end

  def self.exclamation(seed = nil)
    new(:exclamation, seed).to_s
  end

  def initialize(type, seed = nil)
    seed ||= Random.new_seed
    @phrase = self.class.data[type].sample(random: Random.new(seed))
  end

  def to_s
    @phrase
  end
end
