module Support
  def asset(path = nil)
    base = File.expand_path('../../assets', __FILE__)
    path ? File.join(base, path) : base
  end
end
