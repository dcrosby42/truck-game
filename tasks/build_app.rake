
desc "Build the Mac OS X .app bundle TractorGame"
task :app => :clean do
  app_name = "TractorGame"
  build = "build"
  template = "build_resources/#{app_name}.app"
  target_root = "#{build}/#{app_name}.app"
  resources = "#{target_root}/Contents/Resources"
  mkdir_p build
  cp_r template, build
  cp_r [ "config", "lib", "media", "vendor", "binlib" ], resources
  cp "script/bootstrap.rb", resources
end

desc "Remove built deliverables"
task :clean do
  rm_rf "build"
end

desc "Build and run Mac OS X .app version"
task :run_app  => :app do
  sh "open build/TractorGame.app"
end
