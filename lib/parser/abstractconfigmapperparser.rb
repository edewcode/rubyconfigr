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


require 'error/parsererror';

module Parser
  
  class AbstractConfigMapperParser
     
     attr_accessor :config_mapper_file, :data_handler;
     
     def parse
      if @config_mapper_file == nil 
  	    raise RubyConfigr::ParserError , "config_mapper_file cannot be nil";
  	  end
  	  if @data_handler == nil 
  	    raise RubyConfigr::ParserError , "data_handler cannot be nil";
  	  end 	  
     end 
     
     public :parse;
  end 
  
end

