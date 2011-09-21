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


module RubyConfigr

    #PropertyToken is responsible for holding property name=value pairs
	class PropertyToken
     
      # Holds the name of the property 
	  attr_accessor :name;
     
      # Holds the property value 
	  attr_accessor :value;

	  # Holds whether the property is parsed or not 
	  # 'true' - if property is parsed 
	  # 'false' - if proprty is not parsed 
	  attr_accessor :parsed;


	  def initialize(name, value, parsed)  
	  	@name = name;
	  	@value = value;
	  	@parsed = parsed;
	  end 

	end 

end