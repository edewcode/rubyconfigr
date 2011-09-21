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


require 'rubygems';
require 'nokogiri';
require 'parser/abstract_config_parser';
require 'utils/checkutils';
require 'error/parser_error';


module Parser 
  
  # XmlConfigParser is responsible for parsing all the xxxx-config xml files. As the name specifies, this parser only parses the XML files.
  class XmlConfigParser < AbstractConfigParser
  
    # Holds the parsed xml document object
    attr_accessor :doc;
    
    # Holds the logger reference 
    attr_accessor :logger;
    
    
    @@cn = "[#{self.class.name}] ";
    
    
    # Initializes only logger 
    def initialize
      @logger = RubyConfigr::AppLogger.get_logger;
    end 
  
  
  
    # Parses the config xml file 
    # * parses local variables 
    # * parses default properties 
    # * parses categorized properties
    #
    # ==== Arguments 
    # * +config_file+ - config xml file location  
    #
    # ==== Errors
    # * +Error+ - raised when any parsing or other errors occur 
    def parse(config_file)
      super();
      
      begin
        @doc = Nokogiri::XML(File.open(config_file));      
        parse_local_vars();
        parse_local_property();
        parse_category();
      rescue StandardError => e # -- rescue block
        raise e;
      end
      
    end   
    
    
    
    # Parse the <variables/> xml block in config file.
    # 
    # ==== Errors 
    # * +Error+ - when any parsing or validation check or other errors occur 
    def parse_local_vars
      @logger.debug("#{@@cn}inside parse_local_vars");
     begin
        variables_nodes = @doc.xpath("/config/variables");       
        if variables_nodes.length > 0
           # for each <variables/> 
           variables_nodes.each { |variables_node|
             variable_nodes = variables_node.xpath("variable");
             if variable_nodes.length > 0
               # for each <variable/> 
               variable_nodes.each {  |variable_node|
                  RubyConfigr::Utils::CheckUtils.mandatory_attr("name", variable_node, "'name' attribute for <variable> is mandatory");
                  RubyConfigr::Utils::CheckUtils.mandatory_attr("value", variable_node, "'value' attribute for <variable> is mandatory");
                  RubyConfigr::Utils::CheckUtils.attr_value_not_empty("name", variable_node, "'name' attribute for <variable> cannot be empty");
                  
                  @data_handler.handle_local_variables(variable_node['name'], variable_node['value']);
               } # -- end for each <variable/>
             else 
               @logger.warn("#{@@cn}One of the <variables> is empty");      
             end #-- end if                                      
          } #-- end for each <variables/>
        else 
          @logger.warn("#{@@cn}There are no <variables> present.");
        end #-- end if   
      rescue StandardError => e 
        @logger.error("#{@@cn}Error ocurrerd while parsing local variables #{e}");
        raise e;
      end
       @logger.debug("#{@@cn}out of parse_local_vars");
    end
    
    
    
    # Parse the default property ( which are not configured under any category )
    #
    # ==== Errors 
    # * +Error+ - when any parsing or validation check or other errors occur 
    def parse_local_property
       @logger.debug("#{@@cn}inside parse_local_property");
       begin
          prop_nodes = @doc.xpath("/config/property");       
          if prop_nodes.length > 0 
            prop_nodes.each { |prop_node|
              
              RubyConfigr::Utils::CheckUtils.mandatory_attr("name", prop_node, "'name' attribute for <property> is mandatory");
              RubyConfigr::Utils::CheckUtils.mandatory_attr("value", prop_node, "'value' attribute for <property> is mandatory");
              RubyConfigr::Utils::CheckUtils.attr_value_not_empty("name", prop_node, "'name' attribute for <property> cannot be empty");
             
              @data_handler.handle_default_property(prop_node['name'], prop_node['value']);
            }
          else 
            @logger.warn("#{@@cn}There is no default <property> elements present.");
          end  
        rescue StandardError => e 
          @logger.error("#{@@cn}Error ocurrerd while parsing local variables #{e}");
          throw e;
       end
       @logger.debug("#{@@cn}out of parse_local_property"); 
    end
    
    
    
    # Parse categorized property section ( which are configured under <category> element )
    #
    # ==== Errors 
    # * +Error+ - when any parsing or validation check or other errors occur   
    def parse_category
      @logger.debug("#{@@cn}inside parse_category");
       begin
          catnodes = @doc.xpath("/config/category");
          
          if catnodes.length > 0 
              catnodes.each { |catnode|             
              RubyConfigr::Utils::CheckUtils.mandatory_attr("name", catnode, "'name' attribute for <category> is mandatory");
              RubyConfigr::Utils::CheckUtils.attr_value_not_empty("name", catnode, "'name' attribute for <category> cannot be empty");            
              category_name = catnode['name'];            
              propnodes = catnode.xpath("property");
              if propnodes.length > 0
                propnodes.each { |propnode|
                  @data_handler.handle_category_property(category_name, propnode['name'], propnode['value']);
                } # -- end for each 
              else 
                @logger.warn("#{@@cn}No '<property/>' elements present for category '#{category_name}'");               
              end # -- end if 
            } # -- end for each
          else 
            @logger.warn("#{@@cn}There is no <variables> element present.");
          end  #-- end if
        rescue StandardError => e 
          @logger.error("#{@@cn}Error ocurrerd while parsing local variables #{e}");
          throw e;
       end
       @logger.debug("#{@@cn}out of parse_category"); 
    end
    
  end # -- end of class

end # -- end module 


 