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


module Utils
 
 # Supporting file extensions
 module ExtConstants
 	XML = ".xml"; 
 	Properties = ".properties";    
 end 

 # File utility class 
 class FileUtils 
  

  # Get the extension of the 
  # 
  # ==== Arguments 
  # * +file_path+ - absolute path of file 
  # 
  # ==== Returns
  # * +extension+ - file extension  
  def self.get_extension ( file_path )
  	extension = nil;
  	if file_path.end_with?(ExtConstants::XML)
  	 extension = ExtConstants::XML;
    elsif file_path.end_with?(ExtConstants::Properties)
     extension = ExtConstants::Properties;
    end
    return extension; 
  end 

 end #-- end of class 

end #-- end of module 