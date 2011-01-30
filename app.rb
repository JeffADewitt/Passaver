#TODO Ask for a limit to the size of the password
#TODO Remove version and cost from the password
#TODO Ask if user wants numbers.
#TODO Ask if user wants non-alpha non-numeric characters
#TODO Filter out those the user doesn't want


require 'bcrypt'
require 'sequel'
require 'time'
require 'yaml'
require 'json'

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
    correct_choice? service
    name = user_name service
    generate_password service, name
end

def service_choice
    puts "What is this password for? "
    service = gets.chomp
end

def correct_choice? service 
    puts "For #{service}? Is that correct? "
    choice = gets.chomp!
    if choice == "y"
        return true
    else
        return false
    end
end
    
def user_name service
    puts "Please enter your user name for #{service}: "
    user_name = gets.chomp
end

def generate_password service, name
    puts "Here is your Password for #{name} on #{service}: "
    password = BCrypt::Password.create name + service
    save service,name,password
    puts password
end

def save service, name, password
    file = File.open("password","w") 
    file.puts "#{service}: "
    file.puts "  #{name}: #{password}"
    file.close
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
