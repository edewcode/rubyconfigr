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



require 'parser/abstract_config_parser';
require 'applogger';
require 'parser/common_properties_file_parser';
require 'parser/property_token';


module Parser 
  

  # PropertiesConfigParser is responsible for parsing all the xxxx-config properties files. 
  # As the name specifies, this parser only parses the .properties file
  class PropertiesConfigParser < AbstractConfigParser
      include CommonPropertiesFileParser
   
    # Holds the logger reference 
    attr_accessor :logger;

    # (Array) holds list of PropertyToken elements 
    attr_accessor :proplist;

    # (integer) holds current index of @proplist element parsed     
    attr_accessor :current_token_idx;
    
    
    @@cn = "[#{self.class.name}] ";
    
    
    # Initializes only logger 
    def initialize
      @logger = RubyConfigr::AppLogger.get_logger;
    end 
  
  
  
    # Parses the config properties file 
    #
    # ==== Arguments 
    # * +config_file+ - config properties file location  
    #
    # ==== Errors
    # * +StandardError+ - raised when any parsing or other errors occur 
    def parse(config_file)
      super();
      
       @proplist = load_all_properties ( config_file );
       
       # Iterate @proplist and delegate the call accordingly.
       # When following token ( name = value ) pair is found 
       #   * name starting with 'var' - local variables 
       #   * name starting with 'category' - category properties 
       #   * any others are default properties 
       @proplist.each_index do |idx|
         
         token = @proplist[idx];

         if token.parsed  == false 
            key = token.name;
                      
            # when key starts with 'var' name then these are local variables                       
  	        if key.start_with?("var")
  	          parse_local_vars(token);
  	       
           # when key starts with 'category' name then it is a new category defined 
           # for which alias name is provided as value 
  	        elsif key.start_with?("category") 
  	      	  @current_token_idx = idx;
  	          parse_category(token);
           
           # else remaining are all default properties  
            else 
              parse_local_property(token);
               
  	        end #-- end if 
         
         end #-- end if  
         	       
       end # end foreach
   
    end # -- end method  


    
    # Parse the <variables/> xml block in config file.
    # 
    # ==== Errors 
    # * +Error+ - when any parsing or validation check or other errors occur 
    def parse_local_vars(prop_token)
      @logger.debug("#{@@cn}inside parse_local_vars  [prop_token = #{prop_token}]");
      key = prop_token.name;
      name = key[(key.index('.')+1)...key.length];
      value = prop_token.value;
      @data_handler.handle_local_variables(name, value); 
      prop_token.parsed = true;
      @logger.debug("#{@@cn}out of parse_local_vars");
    end
    


    # Parse categorized property section 
    #
    # ==== Errors 
    # * +Error+ - when any parsing or validation check or other errors occur   
    def parse_category ( prop_token )
      @logger.debug("#{@@cn}inside parse_category  [prop_token = #{prop_token}]");
       
       key = prop_token.name;
       category_alias_value = prop_token.value;
       category_name = key[(key.index('.')+1)...key.length];

       # Once the category name is mentioned 
       # then its the start of new category and from next property onwards where ever 
       # new property is defined starting with category alias name that will be 
       # the property defined for that category. ( parse after the category name defintion )
       @current_token_idx += 1;
       
       # check all the property tokens which are the category property for                                             
       (@current_token_idx...(@proplist.length-1)).each do |idx|          
        token = @proplist[idx];
          if token.name.start_with?(category_alias_value)
            prop_with_cat_name = token.name;
            prop_name_only = prop_with_cat_name[(prop_with_cat_name.index('.')+1)...prop_with_cat_name.length];
            @data_handler.handle_category_property(category_name, prop_name_only, token.value);
            token.parsed = true;
          end          
       end      

      @logger.debug("#{@@cn}out of parse_category"); 
    end    
    
    

    # Parse the default property ( which are not configured under any category )
    #
    # ==== Errors 
    # * +Error+ - when any parsing or validation check or other errors occur 
    def parse_local_property(prop_token)
       @logger.debug("#{@@cn}inside parse_local_property [prop_token = #{prop_token}]");
       @data_handler.handle_default_property(prop_token.name, prop_token.value);
       @logger.debug("#{@@cn}out of parse_local_property []"); 
    end
    
    
  end # -- end of class


end # -- end module 


 