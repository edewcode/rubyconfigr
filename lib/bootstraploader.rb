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


require 'applogger';
require 'default_data_handler';
require 'configmanager';
require 'error/loaderror';
require 'parser/xml_config_mapper_parser';
require 'parser/xml_config_parser';
require 'parser/parser_factory';
require 'utils/fileutils';


module RubyConfigr 
  
  # BootstrapLoader is the starting point to load the mapper file from +mapper_path+ envrionment variable and loads provided config xml files, 
  # parses and stores all the configuation values in ConfigManager singleton instance.  
  class BootstrapLoader 
    
    
    # Loads the config mapper xml file and then loads all the config xml files provided in it, parses and store all 
    # information in ConfigManager singleton instance
    #
    # ==== Errors 
    # * +LoadError+ - raised if mapper_path environment variable is not mentioned or is empty   
    def self.load 
      @@logger ||= AppLogger.get_logger();	  
  	
      if ENV["mapper_path"].nil? 
  	    @@logger.fatal("Environment variable 'mapper_path' is not present"); 
  	    raise LoadError , "Environment variable 'mapper_path' is not present";		  
  		elsif  ENV["mapper_path"].strip.eql?("") 
  	    @@logger.fatal("Environment variable 'mapper_path' is empty");    	  
  		  raise LoadError , "Environment variable 'mapper_path' is not present";
  		else  
  		  data_handler = RubyConfigr::DefaultDataHandler.new();
  		  
  		  cfgmgr = RubyConfigr::ConfigManager.instance.get;
  		  
        mapper_path = File.absolute_path(ENV["mapper_path"]);

  		  # get the config-mapper parser 
  		  config_mapper_parser = Parser::ParserFactory.get_configmapper_parser_instance(mapper_path);	  	
  		  config_mapper_parser.config_mapper_file = mapper_path;
  		  config_mapper_parser.data_handler = data_handler;
  		  config_mapper_parser.parse();
  		  

  		  # parse each of the config file locations ( if any )
  		  cfglocs = cfgmgr.config_files_location;
  		  if cfglocs != nil and cfglocs.length > 0
  		    
  		    
  		    # parse the config file 
  		    cfglocs.each do |cfgloc| 
  		      @@logger.debug("parsing config files = #{cfgloc}");

            # get the config parser          
            config_parser = Parser::ParserFactory.get_config_parser_instance(cfgloc);      
            config_parser.data_handler = data_handler;

  		      cfgmgr.create_local_variables_map;
  		      config_parser.parse(cfgloc);
  		      cfgmgr.clear_local_variables_map;
  		    end #-- end of loop
  		  end #-- end if 


  	  end #-- end if 
    end #-- end method
    
  end #-- end class
end #-- end module 


