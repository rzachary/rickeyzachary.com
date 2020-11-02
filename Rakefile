require 'date'
require 'time'
require 'fileutils'

# need some functions to interact with creating the blog posts
def std_input(message)
    print(message)
    STDIN.gets.chomp
end

# Added in a bunch of tasks to help make
# my writing and blogging super easy
def get_slug(title)
    title.downcase.gsub(/\s+/,'-')
end

# I need to come up with a usage for creating new posts

# I want something to create future draft posts
# Such that any draft post will may be in the future
# usage rake new_draft[my-new-draft] or rake new_draft['my-new-draft'] or rake new_draft
desc 'Create new draft post and put it in _drafts/'
task :new_draft, :title do |_t, args|
    title = args.title || std_input('Enter a title for this post (no date): ')
    # I add two weeks to all drafts so that I have enought time to write and research.
    # This acts as the  buffer time, if I finish before I will publish before.
    t = Time.new
    twoweeks = t + ( 2 * 7 * 24 * 60 * 60 )
    draftname = "_drafts/#{twoweeks.strftime('%Y-%m-%d')}-#{get_slug(title)}.md"

    if File.exist?(draftname)
        abort('rake aborted!') if ask("#{draftname} already exists. Do you want to overwrite?", %w[y n]) == 'n'
    end

    puts "Creating new draft: #{draftname}"

    File.open(draftname, 'w') do |post|
        post.puts '---'
        post.puts 'layout: post'
        post.puts "title: \"#{title.gsub(/&/, '&amp;')}\""
        post.puts "date: #{Time.new.strftime('%Y-%m-%d %H:%M:%S %z')}"
        post.puts 'categories: posts'
        post.puts 'tags:'
        post.puts '---'
    end
end


# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post
desc 'Create a new post in _posts/'
task :new_post, :title do |_t, args|
  title = args.title || get_stdin('Enter a title for your post: ')
  filename = "_posts/#{Time.new.strftime('%Y-%m-%d')}-#{get_slug(title)}.md"

  if File.exist?(filename)
    abort('rake aborted!') if ask("#{filename} already exists. Do you want to overwrite?", %w[y n]) == 'n'
  end

  puts "Creating new post: #{filename}"

  File.open(filename, 'w') do |post|
    post.puts '---'
    post.puts 'layout: post'
    post.puts "title: \"#{title.gsub(/&/, '&amp;')}\""
    post.puts "date: #{Time.new.strftime('%Y-%m-%d %H:%M:%S %z')}"
    post.puts 'categories: posts'
    post.puts 'tags:'
    post.puts '---'
  end
end

# usage rake new_page[my-new-page] or rake new_page
desc 'Create a new page'
task :new_page, :title do |_t, args|
  title = args.title || get_stdin('Enter a title for your page: ')

  filename = "#{get_slug(title)}.md"

  if File.exist?(filename)
    abort('rake aborted!') if ask("#{filename} already exists. Do you want to overwrite?", %w[y n]) == 'n'
  end

  puts "Creating new page: #{filename}"

  File.open(filename, 'w') do |page|
    page.puts '---'
    page.puts 'layout: page'
    page.puts "title: \"#{title}\""
    page.puts "permalink: /#{get_slug(title)}/"
    page.puts '---'
  end
end

#publish all drafts from the start until today
desc 'publish all drafts to current date'
task :publish_posts do |task|
  t = Time.new.to_date

  # date regular expression YYYY-MM-DD
  regex = Regexp.new('\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])')
  dest =  Dir.pwd + "_posts/"
  # pull all files currently in the drafts folder
  drafts_dir = Dir.glob("_drafts/*.*")
  for file in drafts_dir
    #check the filename date time to see if it prior to today
    if file.match?(regex) then
      file_date = file.match(regex)
      d = Date.parse(file_date.string)
      if d<= t then
        #if the filename date is prior to today, move the file to the posts
        FileUtils.mv(file, dest)
      end
    end
  end
end
