#TODO Ask for a limit to the size of the password
#TODO Remove version and cost from the password
#TODO Ask if user wants numbers.
#TODO Ask if user wants non alpha-numeric characters
#TODO Filter out those the user doesn't want
#TODO Actually output a string, not a BCrypt class object.


require 'bcrypt'
require 'time'
require 'yaml'
require 'json'
require 'ap'

LOWER_ALPH = ("a".."z").to_a
UPPER_ALPH = ("A".."Z").to_a
NUMERIC = (0..9).to_a
BAD_CHR = [1, 'l', 0, 'O', 'o','i', 'I']
ALPH_NUM = LOWER_ALPH + UPPER_ALPH + NUMERIC - BAD_CHR


if File.exists?("password.yml") && YAML.parse(File.read "password.yml")
  @database = YAML.load File.read "password.yml"
else
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

    puts menu_text
end

def new_password
    service = service_choice
    until correct_choice? service 
        service = service_choice
    end
    user_name = user_name service
    generate_password service, user_name
end

def service_choice
    puts "What is this password for? "
    gets.chomp.downcase
end

def correct_choice? service 
    puts "For #{service}? Is that correct? "
    choice = gets.chomp.downcase
    possible_choices = ["yes", "yep","sure", "y", "yeah", "ok", ""]
    possible_choices.include? choice
end
    
def user_name service
    puts "Please enter your user name for #{service}: "
    gets.chomp.downcase
end

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

def 

def delete_password

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

show_menu
menu_input gets
File.open('password.yml','w').write @database.to_yaml
