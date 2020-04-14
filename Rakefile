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
desc 'Create new draft post and put it in _posts/'
task :new_draft, :title do |_t, args|
    title = args.title || std_input('Enter a title for this post (no date): ')
    # I add two weeks to all drafts so that I have enought time to write and research.
    # This acts as the  buffer time, if I finish before I will publish before.
    twoweeks = Time.now + (2*7*24*60*60)
    draftname = "_drafts/#{twoweeks.now.strftime('%Y-%m-%d %H:%M:%S %z')}-#{slug(title)}.md"

    if File.exist?(draftname)
        abort('rake aborted!') if ask("#{draftname} already exists. Do you want to overwrite?", %w[y n]) == 'n'
    end

    puts "Creating new draft: #{draftname}"

    File.open(draftname, 'w') do |post|
        post.puts '---'
        post.puts 'layout: post'
        post.puts "title: \"#{title.gsub(/&/, '&amp;')}\""
        post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M:%S %z')}"
        post.puts 'categories: posts'
        post.puts 'tags:'
        post.puts '---'
    end
end



