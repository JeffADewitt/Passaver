#TODO Ask for a limit to the size of the pass
#TODO Remove version and cost from the password
#TODO Ask if user wants numbers.
#TODO Ask if user wants non alpha-numeric characters

require 'bcrypt'
require 'time'
require 'yaml'
require 'json'
require 'ap'

# First we need to create an array of lowercase 
# alphabet characters as strings.
LOWER_ALPH = ("a".."z").to_a

# Then we need to make an array of uppercase 
# alphabet characters as strings.
UPPER_ALPH = ("A".."Z").to_a

# Now we generate an array of integers.
NUMERIC = (0..9).to_a

# We also need an array of characters that are ambigious.
BAD_CHR = [1, 'l', 0, 'O', 'o','i', 'I']

# Gathering each array up, and removing the bad characters
# we get our alpha-numeric list.
ALPH_NUM = LOWER_ALPH + UPPER_ALPH + NUMERIC - BAD_CHR

# Now we need to find out if a password file exists.
# The password file is in YAML format, so we also
# need it to be parsable by the YAML interpretor.
if File.exists?("password.yml") && YAML.parse(File.read "password.yml")
    # Assuming the password file exists and YAML can 
    # parse it correctly, read the file and parse the YAML.
    @database = YAML.load File.read "password.yml"
    # The database instance variable should now be a Hash object.
else
    # If YAML can't parse the file, or the file doesn't exist
    # then we need to create a new database Hash.
    @database = {}
end

def show_menu
    menu_text = <<-MENU


        This is the Passaver Menu. Choose a number:

        1. Create a new password
        2. Show a password
        3. Delete a password
        4. Quit Passaver

    MENU

    # Show the user the menu text.
    puts menu_text
end

def new_password
    # Determine the service the user wants to create 
    # a password to use with.
    service = service_choice
    until correct_choice? service 
        service = service_choice
    end

    user = user_choice
    until correct_choice? user 
        user = user_choice
    end
    # user_name = user_name service
    generate_password service, user
end

def service_choice
    puts "What service would you like to do this for? "
    gets.chomp.downcase
end

def correct_choice? service 
    puts "For #{service}? Is that correct? "
    choice = gets.chomp.downcase
    possible_choices = ["yes", "yep","sure", "y", "yeah", "ok", ""]
    possible_choices.include? choice
end

def user_choice
    puts "What user name would you like to do this for? "
    gets.chomp.downcase
end
=begin
def user_name service
    puts "Please enter your user name for #{service}: "
    gets.chomp.downcase
end
=end


def generate_password service, user_name
    puts "Here is your Password for #{user_name} on #{service}: "
    count = 6 + rand(12)
    password = []
    until password.count == count
        password << ALPH_NUM[rand ALPH_NUM.count]
    end
    password = password.join
    puts password
    save service, user_name , password
end

def save service, user_name, password
    if @database.keys.include? service
        add_new_user_name service, user_name, password
    else
        add_new_service service
        save service, user_name, password
    end
end

def add_new_service service
    @database.merge! service => {}
end

def add_new_user_name service, user_name, password
    @database[service].merge! user_name => password
end

def show_password
    puts @database.to_yaml
end

def delete_password
    services = @database.keys
    for service in services do
        number = services.index(service) + 1
        puts "#{number}. #{service}"
    end
    service = service_choice
    until correct_choice? service 
        service = service_choice
    end

    users = @database[service].keys
    for user in users do
        number = services.index(service) + 1
        puts "#{number}. #{service}"
    end
    user = user_choice
    until correct_choice? user 
        user = user_choice
    end
end

def get_crypted_master_password
    BCrypt::Password.new @database[:master]
end

def generate_new_master_password
    puts 'You need to create a master password for this program to use:'
    master_password = gets.chomp!
    @database.merge! master: BCrypt::Password.create(master_password, :cost => 10).to_s
end

def ask_for_master_password
    puts 'Please enter your Master Password:'
    gets.chomp!
end

def verify_master_password entered, crypted
    unless crypted == entered
        puts 'Incorect password entered'
        false
    else
        true
    end
end

def menu_input input
    option = input.chomp.to_i
    case option
        when 1 then new_password
        when 2 then show_password
        when 3 then delete_password
        when 4 then quit
    end
end

def secure_connection
    if @database.keys.include? :master
        validated = false
        until validated
            crypted = get_crypted_master_password
            entered = ask_for_master_password
            validated = verify_master_password entered, crypted
        end
    else
        generate_new_master_password
    end
end

secure_connection
show_menu
menu_input gets
File.open('password.yml','w').write @database.to_yaml