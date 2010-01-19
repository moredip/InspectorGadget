/**
 * Heavily based on ComponentPropertiesEditor.as in FlexSpy 1.2
 * 
 * <p>Code released under WTFPL [http://sam.zoy.org/wtfpl/]</p>
 * @author Arnaud Pichery [http://coderpeon.ovh.org]
 */

package com.lyris.ig
{
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	public class DisplayObjectToXmlConverter
	{
		private static var FILTERED_PROPERTIES: Array = ["textSnapshot", "accessibilityImplementation", "accessibilityProperties", "automationDelegate", "automationValue", "automationTabularData", "numAutomationChildren", "contextMenu", "focusManager", "styleDeclaration", "systemManager", "descriptor", "rawChildren", "verticalScrollBar", "horizontalScrollBar", "stage", "graphics", "focusPane", "loaderInfo", "moduleFactory", "transform", "soundTransform", "inheritingStyles", "nonInheritingStyles" ];
		
		private var _displayObject:DisplayObject;
		private var _description:XML;
		private var _attributeNames: Array;
		private var _attributes: Array;
		
		public function DisplayObjectToXmlConverter(displayObject:DisplayObject)
		{
			_displayObject = displayObject;
			_description = describeType(_displayObject);
			_attributeNames = new Array();
			_attributes = new Array();
		}
		
		public function convert():XML {
			getObjectProperties();
			
			//trace( "raw description: "+_description.toXMLString() );
			
			var xmlNode:XMLNode = new XMLNode( 1, displayObjectType() );
						
			for each( var property:* in _attributes ) {
				if( isSimpleType(property.value) )
					xmlNode.attributes[property.name] = property.value.toString();	
			}
			//trace( "returning "+xmlNode.toString() );

			return new XML(xmlNode);
		}
				
		private function displayObjectType():String {
			return fullDisplayObjectType().split("::").pop();	
		}
		
		private function fullDisplayObjectType():String {
			return _description.@name;
		}

        private function getObjectProperties(): void {				
			for each (var accessor: XML in _description.accessor) {
				recordAttribute( inspectXMLProperty(accessor) );
			}
			for each (var variable: XML in _description.variable) {
				recordAttribute( inspectXMLProperty(accessor) );
			}
			
			for(var name:String in _displayObject) {
				recordAttribute( inspectProperty(name, null, getQualifiedClassName(_displayObject[name]), "readonly") );			
			}
        }
        
        private function inspectXMLProperty(property: XML): * {
			//trace("inspecting property " + property.@name);
			if (property.@access == "writeonly") {
				return null;
			}
			return inspectProperty(property.@name, property.@uri, property.@type, property.@access);
        }
        
        private function inspectProperty(name: String, ns:String, type: String, access: String): * {
			if (name == null || name.length == 0 || name.charAt(0) == '$' || _attributeNames.indexOf(name) >= 0 || FILTERED_PROPERTIES.indexOf(name) >= 0) {
				// Invalid or private property, or already present (describeType method might return several times the same properties)
				return null;
			}

			try {
				var value:Object = getObjectPropertyValue(name, ns);
				return {name:name,value:value};
			} catch (error: Error) {
				// Unable to retrieve property value.
				trace("Failed to retrieve value for property " + name + ": " + error.message);
				return null;
			}
        }
        
        private function getObjectPropertyValue(propertyName: String, namespaceUri: String): * {
        	if (namespaceUri == null || namespaceUri == "") {
        		return _displayObject[propertyName];
        	} else {
        		var ns: Namespace = new Namespace(namespaceUri);
        		return _displayObject.ns::[propertyName];
        	}
        }
        
        private function recordAttribute(attribute:*):void {
			if (attribute) {
				_attributeNames.push(attribute.name);
				_attributes.push(attribute);
			}        	
        }
        
		private static function isSimpleType(object:*):Boolean {
			return (object is Number || object is String || object is Boolean || object is int || object is uint || object is Date); 
		}
	}
}