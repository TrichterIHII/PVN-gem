require_relative "version"

module PVN   
    def self.read(file)
        lines = File.readlines(file)
        values = {}
        @groups = {}
        lines.each_with_index do |element, id|
            tokens = element.split
            line = id +1
            if self.is_comment_or_empty(element)
                # do nothing
            else
                if self.check_syntax(tokens, line, values)
                    if tokens[0].start_with?("g")
                    self.set_value(tokens, line)
                    else
                    values[tokens[1]] = self.set_value(tokens, line)  
                    end
                else
                    self.error_handler("syntax", line, 2)   
                end
            end

        end
        return values
        
    end
    def self.list(var)
        var.each do |key, value|
            puts "#{key} = #{value}"
        end
    end
    def self.is_comment_or_empty(line)
        
        case true
        when line.nil?, line.strip.empty?, line.start_with?("#")
            return true
        else
            return false
        end
        

    end
    def self.check_syntax(tokens, line, values)
        if (tokens[0].end_with?(".edit") && values.key?(tokens[1]) && tokens[0].length == 6) ||
        (tokens[0].end_with?(".new") && !values.key?(tokens[1]) && tokens[0].length == 5) 
            if tokens.length >= 4
                if tokens[2] == "=" 
                    return true
                else 
                    error_handler("syntax", line, 2)
                end 
            
            else 
                error_handler("syntax", line, "universal")
            end
        elsif (tokens[0].end_with?(".edit") && !values.key?(tokens[1]))
            self.error_handler("not_existing", line, 0)
        elsif (tokens[0].end_with?(".new") && values.key?(tokens[1]))
            self.error_handler("already_existing", line, 0)
        else 
            self.error_handler("syntax", line, 0)
        end 
    end
    def self.set_value(tokens, line)
  
        case true
            
        when tokens[0].start_with?("s")
            text_raw = []

            tokens.each_with_index do |element, id|
                if id >= 3
                        text_raw << element
                end
            end
            text = String.new(text_raw.join(" "))
            if text.start_with?('"') && text.end_with?('"')
                text = text.delete_prefix('"')
                text = text.delete_suffix('"')
            elsif text.start_with?('"') == false
                self.error_handler("syntax", line, 3)
            elsif text.end_with?('"') == false
                self.error_handler("syntax", line, tokens.length - 1)
            else
                self.error_handler("syntax", line, "3 - #{tokens.length -1}")
            end
            return text   
        when tokens[0].start_with?("i")
            return tokens[3].to_i
        when tokens[0].start_with?("f")
            return tokens[3].to_f
        when tokens[0].start_with?("b")
            if tokens[3] == "true" || tokens[3] == "yes" || tokens[3] == "1"
                return true
            elsif tokens[3] == "false" || tokens[3] == "no" || tokens[3] == "0"
                return false
            else
                self.error_handler("syntax", line, 3)
            end
        else 
        self.error_handler("syntax", line, 0)
        end       
    end
    def self.group_init()
        case tokens[3]
        when "s", "i", "f", "b"
        end
        @groups = tokens
    end
    def self.error_handler(type, line, token)
        error = ""
        case type
        
        when "syntax"
            error = "Wrong syntax. Look up the syntax in the docs on gihub. A version of the docs should also be bundeled with your pvn package"
        when "not_existing"
            error = "The variable you try to edit is not declared"
        when "already_existing"
            error = "The variable you try to declare is already declared"
        end
        self.logo_printer()
        puts "Error: Line: #{line}, Token: #{token}. #{error}."
        exit()
        
    end

    def self.logo_printer()
        puts    "  _____      ___   _ " 
        puts    " |  _ \\ \\   / / \\ | | "
        puts    " | |_) \\ \\ / /|  \\| | "
        puts    " |  __/ \\ V / | |\\  | "
        puts    " |_|     \\_/  |_| \\_| "
    end
    def self.version()
        puts "Version: #{PVN::VERSION}"
    end
end

