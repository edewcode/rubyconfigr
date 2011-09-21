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



require 'utils/fileutils';
require 'parser/xml_config_mapper_parser';
require 'parser/xml_config_parser';
require 'parser/prop_configmapper_parser';
require 'parser/prop_config_parser';
require 'error/configuration_error';


module Parser

 class ParserFactory 

   # Returns Config Mapper parser implementation instance for given file path. It will check the 
   # extension of the file path and depending on it , will return the suitable parser.
   #
   # ==== Returns
   # * +parser+ - parser implementation  
   #
   # ==== Error 
   # * +ConfigurationError+ - raised when supported extension is not provided
   def self.get_configmapper_parser_instance ( file_path )
    parser = nil;
    file_type = Utils::FileUtils.get_extension(file_path);

    if file_type.eql? ( Utils::ExtConstants::XML )
      parser = Parser::XmlConfigMapperParser.new(); 	
    elsif file_type.eql? ( Utils::ExtConstants::Properties )
      parser = Parser::PropertiesConfigMapperParser.new();  
    else 
      raise ConfigurationErorr, "Extension missing for configuration file #{file_path}";  
    end 

    return parser;
   end 
   


   # Returns Config parser implementation instance for given file path. It will check the 
   # extension of the file path and depending on it , will return the suitable parser.
   #
   # ==== Return
   # * +parser+ - parser implementation  
   #
   # ==== Error 
   # * +ConfigurationError+ - raised when supported extension is not provided
   def self.get_config_parser_instance ( file_path )
   	parser = nil;
    file_type = Utils::FileUtils.get_extension(file_path);

    if file_type.eql? ( Utils::ExtConstants::XML )
      parser = Parser::XmlConfigParser.new(); 	
    elsif file_type.eql? ( Utils::ExtConstants::Properties )
      parser = Parser::PropertiesConfigParser.new();  
    else
      raise ConfigurationErorr, "Extension missing for configuration file #{file_path}";    
    end 
	  
    return parser;
   end 


 end # -- end of clas 

end # -- end of module 