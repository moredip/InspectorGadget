package com.lyris.ig
{
	import flash.display.DisplayObject;
	import sfapi.core.ICustomElementSelector;
	
	public class XpathElementSelector implements sfapi.core.ICustomElementSelector
	{
		private var _elementSelector:ElementSelector;
		
		public function SfapiElementSelector( root:DisplayObject )
		{
			_elementSelector = new ElementSelector( root );
		}

		public function getElement(xpath:String):Object
		{
			return _elementSelector.find(xpath);
		}
		
	}
}