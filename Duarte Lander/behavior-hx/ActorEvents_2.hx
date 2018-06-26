package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_2 extends ActorScript
{          	
	
public var _XSpeed:Float;

public var _YSpeed:Float;

public var _G:Float;

public var _YPropulsion:Float;

public var _XPropulsion:Float;

public var _friction:Float;

public var _flying:String;

public var _gliding:String;

public var _isOver:Bool;

public var _LandingSpeed:Float;

public var _isMoving:Bool;

public var _LandingTriggered:Bool;

public var _Multiplier:Float;

public var _CrashingTriggered:Bool;
    
/* ========================= Custom Event ========================= */
public function _customEvent_Crash():Void
{
        if(!(_CrashingTriggered))
{
            Engine.engine.setGameAttribute("Fuel", (Engine.engine.getGameAttribute("Fuel") - 100));
            _CrashingTriggered = true;
propertyChanged("_CrashingTriggered", _CrashingTriggered);
            playSound(getSound(9));
}

}

    
/* ========================= Custom Event ========================= */
public function _customEvent_Land():Void
{
        if(!(_LandingTriggered))
{
            Engine.engine.setGameAttribute("Score", (Engine.engine.getGameAttribute("Score") + (50 * _Multiplier)));
            Engine.engine.setGameAttribute("Fuel", (Engine.engine.getGameAttribute("Fuel") + (200 * _Multiplier)));
            playSound(getSound(10));
            _LandingTriggered = true;
propertyChanged("_LandingTriggered", _LandingTriggered);
}

}


 
 	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("XSpeed", "_XSpeed");
_XSpeed = 0.0;
nameMap.set("YSpeed", "_YSpeed");
_YSpeed = 0.0;
nameMap.set("G", "_G");
_G = 0.05;
nameMap.set("YPropulsion", "_YPropulsion");
_YPropulsion = 0.1;
nameMap.set("XPropulsion", "_XPropulsion");
_XPropulsion = 0.02;
nameMap.set("friction", "_friction");
_friction = 0.005;
nameMap.set("flying", "_flying");
nameMap.set("gliding", "_gliding");
nameMap.set("isOver", "_isOver");
_isOver = false;
nameMap.set("LandingSpeed", "_LandingSpeed");
_LandingSpeed = 5.0;
nameMap.set("isMoving", "_isMoving");
_isMoving = false;
nameMap.set("LandingTriggered", "_LandingTriggered");
_LandingTriggered = false;
nameMap.set("Multiplier", "_Multiplier");
_Multiplier = 0.0;
nameMap.set("CrashingTriggered", "_CrashingTriggered");
_CrashingTriggered = false;

	}
	
	override public function init()
	{
		    
/* ======================== When Creating ========================= */
        _flying = ("" + "Flying");
propertyChanged("_flying", _flying);
        _gliding = ("" + "Gliding");
propertyChanged("_gliding", _gliding);
        actor.setX(40);
        actor.setY(40);
        _isMoving = true;
propertyChanged("_isMoving", _isMoving);
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        _YSpeed = asNumber((_YSpeed + _G));
propertyChanged("_YSpeed", _YSpeed);
        if(!(_isOver))
{
            if(isKeyDown("up"))
{
                _YSpeed = asNumber((_YSpeed - _YPropulsion));
propertyChanged("_YSpeed", _YSpeed);
}

            if(isKeyDown("right"))
{
                _XSpeed = asNumber((_XSpeed + _XPropulsion));
propertyChanged("_XSpeed", _XSpeed);
}

            else if(isKeyDown("left"))
{
                _XSpeed = asNumber((_XSpeed - _XPropulsion));
propertyChanged("_XSpeed", _XSpeed);
}

            else
{
                if((_XSpeed > 0))
{
                    _XSpeed = asNumber((_XSpeed - _friction));
propertyChanged("_XSpeed", _XSpeed);
}

                if((_XSpeed < 0))
{
                    _XSpeed = asNumber((_XSpeed + _friction));
propertyChanged("_XSpeed", _XSpeed);
}

}

            actor.setYVelocity(_YSpeed);
            actor.setXVelocity(_XSpeed);
}

}
});
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if(_isMoving)
{
            if((_XSpeed < 0))
{
                Engine.engine.setGameAttribute("Speed", (-(_XSpeed) + _YSpeed));
}

            else if((_YSpeed < 0))
{
                Engine.engine.setGameAttribute("Speed", (_XSpeed + -(_YSpeed)));
}

            else if(((_XSpeed < 0) && (_YSpeed < 0)))
{
                Engine.engine.setGameAttribute("Speed", (-(_XSpeed) + -(_YSpeed)));
}

            else
{
                Engine.engine.setGameAttribute("Speed", (_XSpeed + _YSpeed));
}

}

}
});
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if((actor.getScreenX() < 0))
{
            actor.setX(0);
            _XSpeed = asNumber(0);
propertyChanged("_XSpeed", _XSpeed);
}

        if(((actor.getScreenX() + (actor.getWidth())) > getScreenWidth()))
{
            actor.setX((getScreenWidth() - (actor.getWidth())));
            _XSpeed = asNumber(0);
propertyChanged("_XSpeed", _XSpeed);
}

        if((actor.getScreenY() < 0))
{
            actor.setY(0);
            _YSpeed = asNumber(0);
propertyChanged("_YSpeed", _YSpeed);
}

        actor.setXVelocity(_XSpeed);
        actor.setYVelocity(_YSpeed);
}
});
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if((!(_isOver) && _isMoving))
{
            if(isKeyDown("up"))
{
                actor.setAnimation("" + _flying);
}

            else
{
                actor.setAnimation("" + _gliding);
}

}

        else
{
            actor.setAnimation("" + _gliding);
}

}
});
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if(_isMoving)
{
            if(isKeyDown("up"))
{
                Engine.engine.setGameAttribute("Fuel", (Engine.engine.getGameAttribute("Fuel") - 1));
}

}

}
});
    
/* ======================== Something Else ======================== */
addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        _YSpeed = asNumber(0);
propertyChanged("_YSpeed", _YSpeed);
        _XSpeed = asNumber(0);
propertyChanged("_XSpeed", _XSpeed);
        event.thisActor.setXVelocity(_XSpeed);
        event.thisActor.setYVelocity(_YSpeed);
}
});
    
/* ======================= Member of Group ======================== */
addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
{
if(wrapper.enabled && sameAsAny(getActorGroup(5),event.otherActor.getType(),event.otherActor.getGroup()))
{
        _isMoving = false;
propertyChanged("_isMoving", _isMoving);
        if(!(_isOver))
{
            if(((internalGetGroup(event.otherActor, event.otherShape, event) == getActorGroup(6)) && (Engine.engine.getGameAttribute("Speed") < _LandingSpeed)))
{
                if(((actor.getScreenX() >= 0) && ((actor.getScreenX() + (actor.getWidth())) <= 80)))
{
                    _Multiplier = asNumber(.5);
propertyChanged("_Multiplier", _Multiplier);
                    _customEvent_Land();
}

                else if((((actor.getScreenX() >= 300) && ((actor.getScreenX() + (actor.getWidth())) <= 380)) || ((actor.getScreenX() >= 734) && ((actor.getScreenX() + (actor.getWidth())) <= 814))))
{
                    _Multiplier = asNumber(3);
propertyChanged("_Multiplier", _Multiplier);
                    _customEvent_Land();
}

                else if(((actor.getScreenX() >= 575) && ((actor.getScreenX() + (actor.getWidth())) <= 655)))
{
                    _Multiplier = asNumber(2);
propertyChanged("_Multiplier", _Multiplier);
                    _customEvent_Land();
}

                else if(((actor.getScreenX() >= 944) && ((actor.getScreenX() + (actor.getWidth())) <= 1024)))
{
                    _Multiplier = asNumber(5);
propertyChanged("_Multiplier", _Multiplier);
                    _customEvent_Land();
}

                else if(((actor.getScreenX() >= 822) && ((actor.getScreenX() + (actor.getWidth())) <= 902)))
{
                    _Multiplier = asNumber(20);
propertyChanged("_Multiplier", _Multiplier);
                    _customEvent_Land();
}

                else
{
                    _customEvent_Crash();
}

}

            else
{
                _customEvent_Crash();
}

            runLater(1000 * 0.5, function(timeTask:TimedTask):Void {
                        actor.setX(40);
                        actor.setY(40);
                        _isMoving = true;
propertyChanged("_isMoving", _isMoving);
                        runLater(1000 * 0.2, function(timeTask:TimedTask):Void {
                                    _LandingTriggered = false;
propertyChanged("_LandingTriggered", _LandingTriggered);
                                    _CrashingTriggered = false;
propertyChanged("_CrashingTriggered", _CrashingTriggered);
}, actor);
}, actor);
}

}
});
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if((Engine.engine.getGameAttribute("Fuel") <= 0))
{
            Engine.engine.setGameAttribute("Fuel", 0);
            _isOver = true;
propertyChanged("_isOver", _isOver);
            shoutToScene("_customEvent_" + "GameOver");
}

}
});
    
/* =========================== Keyboard =========================== */
addKeyStateListener("up", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
{
if(wrapper.enabled && pressed)
{
        loopSoundOnChannel(getSound(8), Std.int(1));
}
});
    
/* =========================== Keyboard =========================== */
addKeyStateListener("up", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
{
if(wrapper.enabled && released)
{
        stopSoundOnChannel(Std.int(1));
}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}