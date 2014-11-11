class Sprockets::DirectiveProcessor
  def process_depend_on_ref_directive
    Dir.glob(Rails.root.join('.git', 'refs', 'heads', '*').to_s).each do |path|
      context.depend_on(path)
    end
  end
end
