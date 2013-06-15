source = "templates/emojifont/emojifont.css.erb"
target = "build/emojifont/emojifont.css"
containing_directory = target.pathmap('%d')

directory containing_directory
file target => [containing_directory, source] do
  @emoji_unicode_range = Emojistatic.generate_css_map
  results = ERB.new( File.read(source) ).result

  File.open(target, 'w') do |f|
    f.write(results)
  end
end

desc "Generate emojifont CSS ruleset"
task :emojifont => target
task 'clobber:emojifont' do
  rm target
end
