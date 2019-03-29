## Serve
namespace :serve do
  def serve(env)
    puts "*" * 50
    puts "* Serving #{env.upcase}"
    puts "*" * 50
    system "LOCALE=#{env} bundle exec middleman"
  end

  desc "Serve NL"
  task :nl do
    serve :nl
  end

  desc "Serve DE"
  task :de do
    serve :de
  end

  desc "Serve EN"
  task :en do
    serve :en
  end
end

## Build for production
namespace :build do
  def build(env)
    puts "*" * 50
    puts "* Building #{env.upcase} ..."
    puts "*" * 50
    system "LOCALE=#{env} PRODUCTION=true bundle exec middleman build --clean" or exit(1)
  end

  desc "Build NL"
  task :nl do
    build :nl
    FileUtils.rm_rf("build/de", verbose: true)
    FileUtils.rm_rf("build/en", verbose: true)
  end

  desc "Build DE"
  task :de do
    build :de
    FileUtils.rm_rf("build/nl", verbose: true)
    FileUtils.rm_rf("build/en", verbose: true)
    FileUtils.rm_rf("build/de", verbose: true)
  end

  desc "Build EN"
  task :en do
    build :en
    FileUtils.rm_rf("build/nl", verbose: true)
    FileUtils.rm_rf("build/de", verbose: true)
  end
end

## Test
namespace :test do
  def test(env)
    begin
      Rake::Task["build:#{env}"].invoke
    rescue SystemExit => e
      puts "*" * 50
      puts "* Build failed, skipping test (locale #{env.upcase})"
      puts "*" * 50
      exit(e.status)
    end

    puts "*" * 50
    puts "* Build successful, Test #{env.upcase} ... "
    puts "*" * 50
    system "ruby test.rb" or exit(1)
  end

  desc "Test NL"
  task :nl do
    test :nl
  end

  desc "Test DE"
  task :de do
    test :de
  end

  desc "Test EN"
  task :en do
    test :en
  end
end

desc "Test all locales"
task :test => ["test:nl", "test:de", "test:en"]
