/**
 * getDisplayObjectChildren() based upon:
 * 
 *  ComponentTreeItem.as in FlexSpy 1.2
 * 
 * <p>Code released under WTFPL [http://sam.zoy.org/wtfpl/]</p>
 * @author Arnaud Pichery [http://coderpeon.ovh.org]
 */
package com.lyris.ig
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	public class DomWalker
	{
		private var _root:DisplayObject;
		private var _xmlRepresentation:XML;
		private var _uidMap:Object;
		
		public function DomWalker(root:DisplayObject)
		{
			_root = root;
			_uidMap = new Object();
		}
		
		public function get domAsXML():XML{ return _xmlRepresentation; }
		
		public function discoverDom():void {
			trace('walking DOM...');
			_xmlRepresentation = convertDisplayObjectToXmlTree( _root );
			trace('...walk complete'); 
		}
		
		public function getElementByUid(uid:String):DisplayObject {
			return _uidMap[uid] as DisplayObject;
		}
		
		private function convertDisplayObjectToXmlTree(displayObject:DisplayObject):XML {
			var rootXmlNode:XML = representDisplayObjectAsXml( displayObject );
			registerDisplayObject( displayObject, rootXmlNode );
			
			var children:Array = getDisplayObjectChildren(displayObject);
			
			for each( var child:DisplayObject in children ) {
				var childXmlNode:XML = convertDisplayObjectToXmlTree(child);
				rootXmlNode.appendChild(childXmlNode);
			}
			
			return rootXmlNode; 
		}
		
		private function representDisplayObjectAsXml(displayObject:DisplayObject):XML {
			var converter:DisplayObjectToXmlConverter = new DisplayObjectToXmlConverter(displayObject);
			return converter.convert();
		}
		
		private function registerDisplayObject(displayObject:DisplayObject,xmlRepresentation:XML):void {
			var uid:String = xmlRepresentation.@uid;
			if( null != uid && '' != uid ) {
				_uidMap[uid] = displayObject;
			}
		}
		
		private function getDisplayObjectChildren(displayObject:DisplayObject):Array {
			var component: UIComponent = displayObject as UIComponent;
			if (component == null)
				return []; // Only UIComponents have children.
		
			var children: Array = new Array();
			
			// Add the "standard" children
			for (var i: int = 0; i < component.numChildren; i++) {
				var child: DisplayObject = component.getChildAt(i);
				
//PNH Don't think this is required
/*				
				// Check that this child is not already present in the collection
 				if (child != null && !containsChild(children, child)) {
					children.push(new ComponentTreeItem(child, this));
				}
*/
				if( child != null )
					children.push(child);
			}

//PNH skipping this for now
/*			
			// Add the "Chrome" children
			if (component is IRawChildrenContainer) {
				var childList: IChildList = IRawChildrenContainer(component).rawChildren;
				var chromeChildren: Array = new Array();
				var chromeItem: ComponentTreeChrome = new ComponentTreeChrome(chromeChildren, this);

				// Add the chrome children
				for (var k: int = 0; k < childList.numChildren; k++) {
					var kchild: DisplayObject = childList.getChildAt(k);
					
					// Check that this child is not already present in the collection
					if (!containsChild(children, kchild) && kchild != null) {
						chromeChildren.push(new ComponentTreeItem(kchild, chromeItem));
					}
				}
				
				if (chromeChildren.length > 0) {
					children.push(chromeItem);
				}				
			}
*/
			return children;
		}
	}
}