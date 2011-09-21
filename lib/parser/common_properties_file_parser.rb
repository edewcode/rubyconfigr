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
require 'parser/property_token';


module CommonPropertiesFileParser

   # Splits the name = value pair and returns as token array.
   #    
   # ==== Arguments 
   # * +nv_pair+ - name-value property pair
   #  
   # ==== Returns 
   # * +tokens+ - 'nil' when nv_pair is empty, else 
   # 		    - token[0] contains key , token[1] contains value		
   # 
   # ==== Errors
   # * +StandardError+ - raised when any kind of errors occur while loading properties from file  
   def split_pair(nv_pair)
      tokens = nil;
        tokens = nv_pair.split('=');
        if tokens == nil && tokens.length > 2
           raise ParserError , "Error parsing #{nv_pair} in #{@config_file_path}. (name = value) pair not proper."; 
        else
          tokens[0] = tokens[0].strip.gsub(/[\n\t]/,"");
          tokens[1] = tokens[1].strip.gsub(/[\n\t]/,""); 
        end 
      return tokens;
    end 



   # Load all the properties for given path and return the array of tokens ( i.e name-value pairs )
   # 
   # ==== Arguments
   # * +file_path+ - absolute file path location of properties file
   # 
   # ==== Returns 
   # * +@proplist+ - list of properties as tokens i.e name-value pairs
   # 
   # ==== Errors
   # * +StandardError+ - raised when any kind of errors occur while loading properties from file  
   def load_all_properties(file_path)            
      proplist = [];

      begin
        File.open(file_path, "r") do |file| 
          while line = file.gets
             line = line.strip;
             next if line.eql?("");
             next if line[0].eql?('#');                  
                        
             # get the tokens for each property line             
             tokens = self.split_pair(line);                           
             proplist.push(RubyConfigr::PropertyToken.new(tokens[0], tokens[1], false));
                                                    
          end
        end
      rescue StandardError => e        
        raise e;
      end 
      
      return proplist; 
    end # -- end of load_all_properties


 
 end # -- end of module 