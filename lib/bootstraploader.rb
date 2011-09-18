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
require 'defaultdatahandler';
require 'configmanager';
require 'error/LoadError';
require 'parser/xmlconfigmapperparser';
require 'parser/xmlconfigparser';


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
  	    @@logger.fatal("environment variable 'mapper_path' is not present"); 
  	    raise LoadError , "Environment variable 'mapper_path' is not present";		  
  		elsif  ENV["mapper_path"].strip.eql?("") 
  	    @@logger.fatal("environment variable 'mapper_path' is empty");    	  
  		  raise LoadError , "Environment variable 'mapper_path' is not present";
  		else  
  		  data_handler = RubyConfigr::DefaultDataHandler.new();
  		  
  		  cfgmgr = RubyConfigr::ConfigManager.instance.get;
  		  
  		  # get the configuration mapper factory and parse the config mapper file 
  		  config_mapper_parser = Parser::XmlConfigMapperParser.new(); 		  	
  		  config_mapper_parser.config_mapper_file = File.absolute_path(ENV["mapper_path"]);
  		  config_mapper_parser.data_handler = data_handler;
  		  config_mapper_parser.parse();
  		  
  		  # parse each of the config file locations ( if any )
  		  cfglocs = cfgmgr.config_files_location;
  		  if cfglocs != nil and cfglocs.length > 0
  		    
  		    # get the config xml parser
  		    config_parser = Parser::XmlConfigParser.new();   
  		    config_parser.data_handler = data_handler;
  		    
  		    # parse the config file 
  		    cfglocs.each do |cfgloc| 
  		      @@logger.debug("parsing config files = #{cfgloc}");
  		      cfgmgr.create_local_variables_map;
  		      config_parser.parse(cfgloc);
  		      cfgmgr.clear_local_variables_map;
  		    end #-- end of loop
  		  end #-- end if 
  		  
  	  end #-- end if 
    end #-- end method
  
    
  end #-- end class
end #-- end module 


