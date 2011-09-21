#Copyright 2011 edewcode.com
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


# Author:  Kartik Narayana Maringanti
# Contact: edewcode@gmail.com, mn.kartik@gmail.com



require 'error/parser_error';
require 'parser/abstract_config_mapper_parser';
require 'applogger';
require 'parser/common_properties_file_parser';


module Parser

  # PropertiesConfigParser is responsible for parsing all the xxxx-config properties files. 
  # As the name specifies, this parser only parses the .properties file
  class PropertiesConfigMapperParser < AbstractConfigMapperParser
      include CommonPropertiesFileParser

    attr_accessor :proplist;
    attr_accessor :logger;

    @@cn = "[#{PropertiesConfigMapperParser.name}] ";


    def initialize            
      @logger = RubyConfigr::AppLogger.get_logger();
    end 


    def parse
      super;
      
      @proplist = load_all_properties(@config_mapper_file);

      @proplist.each do |tokens|
       key = tokens.name;
       if key.start_with?("gvar") # "gvar"
         parse_global_vars(tokens);
       
       elsif key.start_with?("config")  # "config"
         parse_config_locations(tokens);

       end #-- end if 

      end # end foreach

    end 





    def parse_global_vars ( prop_tokens )
      @logger.debug("#{@@cn} inside parse_global_vars  params : [ prop_tokens = #{prop_tokens}]");
      
      key =  prop_tokens.name;
      value = prop_tokens.value;

      global_var_idx = key.index('.');
      
      # checks keys like 'gvarxxxx' which doesnt provide '.'
      if global_var_idx == nil 
        raise ParserError,  "Invalid global variable '#{prop_tokens}'' found in #{@config_mapper_file}";
      end 

      # checks keys like 'gvar.' which doesnt provide any global variable 
      if value.length == 0
        raise ParserError, "No global variable provided '#{prop_tokens}' found in #{@config_mapper_file}";
      end      

      global_var_name = key[(global_var_idx+1)...key.length];
      @data_handler.handle_global_variables(global_var_name, value );                                                  
      
      @logger.debug("#{@@cn} outside parse_global_vars");
    end 
    

    
    def parse_config_locations ( prop_tokens )
      @logger.debug("@@{cn} inside parse_config_locations  params : [ prop_tokens = #{@prop_tokens} ]");
      
      key =  prop_tokens.name;
      value = prop_tokens.value;

      confloc_idx = key.index('.');
      
      # checks keys like 'configlocationxxxx' which doesnt provide '.'
      if confloc_idx == nil 
        raise ParserError,  "Invalid config location '#{prop_tokens}'' found in #{@config_mapper_file}";
      end 

      # checks keys like 'config.location=' which doesnt provide any global variable 
      if value.length == 0
        raise ParserError, "No config location provided '#{prop_tokens}' found in #{@config_mapper_file}";
      end 
            
      conflocs = value.split(',');
      @logger.debug("@@{cn} conflocs = #{conflocs}");

      conflocs.each do |loc_path|
        loc_path = loc_path.strip.gsub(/\n\t/,"");
        @logger.debug("@@{cn} #{loc_path}");
        @data_handler.handle_config_location(loc_path);
      end

      @logger.debug("outside parse_config_locations");
    end
 

 
     
  end # -- end of class 

end # -- end of module