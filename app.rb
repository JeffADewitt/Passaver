require 'bcrypt'
require 'sequel'
require 'time'
require 'yaml'
require 'json'

def show
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
    
end

def service_choice
    print "What is this password for? "
    service = gets.chomp
end

def correct_choice? service 
    print "For #{service}? Is that correct?"
    if choice = gets.chomp! == "yes"
        return true
    else
        return false
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


show

