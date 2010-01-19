package com.lyris.ig
{
	import flash.display.DisplayObject;
	
	import memorphic.xpath.XPathQuery;
	
	public class ElementSelector
	{
		private var _root:DisplayObject;
		private var _domWalker:DomWalker;
		
		public function ElementSelector( root:DisplayObject )
		{
			_root = root;
			_domWalker = null;
		}
		
		public function exists( xpath:String ):Boolean {
			return find(xpath) != null;
		}

		public function find( xpath:String ):DisplayObject {
			trace( 'selecting: '+xpath );
			
			if( !_domWalker) walkDom();
			
			var query:XPathQuery = new XPathQuery(xpath);
			var result:XMLList = query.exec(_domWalker.domAsXML);
			
			if( 0 == result.length() )
			{
				trace('no results');
				return null;				
			}
			
			var uid:String = result[0].@uid;
			
			if( null == uid || '' == uid )
			{
				trace( "found element has no uid:\n"+result[0].toXMLString() );
				return null;
			}
			
			var element:DisplayObject = _domWalker.getElementByUid(uid);
			
			trace( ( null == element ) ? '!!!element not found!!!' : 'element found' );
			
			return element;
		}		
		
		private function walkDom():void {
			_domWalker = new DomWalker(_root);
			_domWalker.discoverDom();
		}
	}
}