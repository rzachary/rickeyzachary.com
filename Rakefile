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
    draftname = "_drafts/#{Time.now.strftime"






end


desc 'Publish a draft essentially moving it from one folder to another '