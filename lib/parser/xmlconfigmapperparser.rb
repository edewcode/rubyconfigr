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



require 'rubygems'
require 'nokogiri'
#require 'xml'
require 'parser/abstractconfigmapperparser';
require 'error/parsererror';
require 'utils/checkutils';
require 'yaml';


module Parser
  
  # XmlConfigMapperParser will parse the mapper xml file and pass the data to the default data handler
  class XmlConfigMapperParser < AbstractConfigMapperParser
    
    # Holds document object   
    attr_accessor :doc;
    
    # Holds the logger reference 
    attr_accessor :logger;
    
    
    # Constructor which initializes only logger 
    def initialize
      @logger = RubyConfigr::AppLogger.get_logger();
    end 
    
    
    # Responsible for following 
    # * parsing the mapper xml file location, set in @config_mapper_file property
    # * get the document object and assign to #doc 
    # * retrieves the necessary configuration values and delegates call to @data_handler methods corresponding to the parsed elements
    #
    # ==== Error 
    # * +Error+ - raised when any parsing error or condition check fails and when the root element is not <config-mapper> 
  	def parse
      super;
          
      begin  # -- start error block
    		@doc = Nokogiri::XML(File.open(@config_mapper_file));
    		rootnode = @doc.xpath("config-mapper");
    		if rootnode.length == 0 
    		 @logger.warn("<config-mapper> must be the root element");
    		 raise RubyConfigr::ParserError , "<config-mapper> must be the root element";
    		end
    		parse_global_vars();
    		parse_config_locations();
  		rescue StandardError => e # -- rescue block
  		  raise e; 
  		end # -- end of error block 
  	end   
  		
  	
  	# Parses the <global-variables> section in the mapper config xml
    #
    # ==== Errors 
    # * +Error+ - raised when any parsing error or any condition check fails
  	def parse_global_vars 
  		begin
  			nodes = @doc.xpath("/config-mapper/global-variables/variable");	 			
  			if nodes.length > 0 
  				nodes.each { |node|
  				  
  				  RubyConfigr::Utils::CheckUtils.mandatory_attr("name", node, "'name' attribute for <variable> under <global-variables> is mandatory");
  				  RubyConfigr::Utils::CheckUtils.mandatory_attr("value", node, "'value' attribute for <variable> under <global-variables> is mandatory");
  				  RubyConfigr::Utils::CheckUtils.attr_value_not_empty("name", node, "'name' attribute for <variable> under <global-variables> cannot be empty");
  				  
  				  @data_handler.handle_global_variables(node['name'], node['value']);
  			  }
  			else 
  			  @logger.warn("There are no <global-variables> element present.");
  			end  
  		rescue StandardError => e	
  			@logger.error("Error ocurrerd while parsing global variables #{e}");
  			throw e;
  		end		
  	end 
  	
  	
  	# parse the config location section in the mapper config xml 
  	# Parses the <global-variables> section in the mapper config xml
    #
    # ==== Errors 
    # * +Error+ - raised when any parsing error or any condition check fails
    # * +ParserError+ - raised when there are no <config> elements specified
  	def parse_config_locations
  	  begin
  			nodes = @doc.xpath("/config-mapper/config");			
  			if nodes.length > 0 
  				nodes.each { |node|
  
           RubyConfigr::Utils::CheckUtils.mandatory_attr("location", node, "'location' attribute for <config> is mandatory");        
           RubyConfigr::Utils::CheckUtils.attr_value_not_empty("location", node, "'location' attribute for <config> cannot be empty");
           
           @data_handler.handle_config_location(node['location']);
  			  }
  			else 
  			 raise RubyConfigr::ParserError , "There must be atleast one <config> element present in the config mapper file.";
  			end  
  		rescue StandardError => e	
  			 @logger.error("Error ocurrerd while parsing config location #{e}");
  			 throw e;
  		end		
  	end 
  	
  	
  	public  :parse;
  	private :parse_global_vars, :parse_config_locations;
  	
  end # -- end class 
  
end # -- end module



