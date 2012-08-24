/******************************************************
 *                                                    *
 *   PHYSICS CLASSES AND CONSTANTS FOR EMO-FRAMEWORK  *
 *                                                    *
 *            !!DO NOT EDIT THIS FILE!!               *
 ******************************************************/

PHYSICS_BODY_TYPE_STATIC     <- 0;
PHYSICS_BODY_TYPE_KINEMATIC  <- 1;
PHYSICS_BODY_TYPE_DYNAMIC    <- 2;

PHYSICS_SHAPE_TYPE_UNKNOWN   <- -1;
PHYSICS_SHAPE_TYPE_CIRCLE    <-  0;
PHYSICS_SHAPE_TYPE_POLYGON   <-  1;

JOINT_TYPE_UNKNOWN   <-  0;
JOINT_TYPE_REVOLUTE  <-  1;
JOINT_TYPE_PRISMATIC <-  2;
JOINT_TYPE_DISTANCE  <-  3;
JOINT_TYPE_PULLEY    <-  4;
JOINT_TYPE_MOUSE     <-  5;
JOINT_TYPE_GEAR      <-  6;
JOINT_TYPE_LINE      <-  7;
JOINT_TYPE_WELD      <-  8;
JOINT_TYPE_FRICTION  <-  9;

PHYSICS_STATE_NULL    <- -1;
PHYSICS_STATE_ADD     <- 0;
PHYSICS_STATE_PERSIST <- 1;
PHYSICS_STATE_REMOVE  <- 2;

PTM_RATIO <- 32;

emo.physics <- {};

class emo.physics.World {
    id      = null;
    physics = emo.Physics();
    scale   = null;
    sprites = null;
    groundBody = null;
    function constructor(gravity, doSleep) {
        id = physics.newWorld(gravity, doSleep);
        scale = PTM_RATIO;
        sprites = [];
    }
    function enableContactListener() {
        return physics.world_enableContactListener(id);
    }
    function enableContactState(contactType, enabled) {
        return physics.world_enableContactState(id, contactType, enabled);
    }
    
    function setGravity(gravity) {
        return physics.world_setGravity(id, gravity);
    }
    
    function getGravity() {
        return emo.Vec2.fromArray(physics.world_getGravity(id));
    }
    
    function setScale(pixelToMeterRatio) {
        scale = pixelToMeterRatio;
    }
    function getScale() {
        return scale;
    }

    function getWorldCoord(x, y) {
        return emo.Vec2(x.tofloat() / scale.tofloat(), y.tofloat() / scale.tofloat());
    }

    function addPhysicsObject(pSprite) {
        sprites.append(pSprite);
    }
    
    function removePhysicsObject(pSprite) {
        local idx = sprites.find(pSprite);
        if (idx != null) sprites.remove(idx);
    }
    
    function createBody(bodydef) {
        return emo.physics.Body(physics.createBody(id, bodydef));
    }
    
    function destroyBody(body) {
        return physics.destroyBody(id, body.id);
    }

    function getGroundBody() {
        if (groundBody == null) {
            groundBody = emo.physics.Body(physics.createGroundBody(id));
        }
        return groundBody;
    }
    
    function createJoint(jointdef) {
        jointdef.update();
        switch(jointdef.type) {
        case JOINT_TYPE_DISTANCE:
            return emo.physics.DistanceJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_FRICTION:
            return emo.physics.FrictionJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_GEAR:
            return emo.physics.GearJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_LINE:
            return emo.physics.LineJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_PRISMATIC:
            return emo.physics.PrismaticJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_PULLEY:
            return emo.physics.PulleyJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_REVOLUTE:
            return emo.physics.RevoluteJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_WELD:
            return emo.physics.WeldJoint(physics.createJoint(id, jointdef.id));
            break;
        case JOINT_TYPE_MOUSE:
            return emo.physics.MouseJoint(physics.createJoint(id, jointdef.id));
            break;
        }
    }
    
    function destroyJoint(joint) {
        return physics.destroyJoint(id, joint.id);
    }
    
    function step(timeStep, velocityIterations, positionIterations) {
        
        local r = physics.world_step(id, timeStep, velocityIterations, positionIterations);
        
        for (local i = 0; i < sprites.len(); i++) {
            sprites[i].update(timeStep, scale);
        }
        
        return r;
    }
    
    function clearForces() {
        return physics.world_clearForces(id);
    }
    
    function setAutoClearForces(flag) {
        return physics.world_setAutoClearForces(id, flag);
    }
    
    function getAutoClearForces() {
        return physics.world_getAutoClearForces(id);
    }
}

class emo.physics.Body {
    id      = null;
    physics = emo.Physics();
    function constructor(_id) {
        id = _id;
    }
    
    function createFixture(...) {
        if (vargv.len() == 1) {
            return emo.physics.Fixture(id, physics.createFixture(id, vargv[0]));
        } else if (vargv.len() >= 2) {
            local def   = emo.physics.FixtureDef();
            def.shape   = vargv[0];
            def.density = vargv[1];
            return emo.physics.Fixture(id, physics.createFixture(id, def));
        }
        return null;
    }
    
    function destroyFixture(fixture) {
        return physics.destroyFixture(id, fixture.id);
    }
    
    function setTransform(position, angle) {
        return physics.body_setTransform(id, position, angle);
    }
    
    function getPosition() {
        return emo.Vec2.fromArray(physics.body_getPosition(id));
    }
    
    function getAngle() {
        return physics.body_getAngle(id);
    }
    
    function getWorldCenter() {
        return emo.Vec2.fromArray(physics.body_getWorldCenter(id));
    }
    
    function getLocalCenter() {
        return emo.Vec2.fromArray(physics.body_getLocalCenter(id));
    }
    
    function setLinearVelocity(v) {
        return physics.body_setLinearVelocity(id, v);
    }
    
    function getLinearVelocity() {
        return emo.Vec2.fromArray(physics.body_getLinearVelocity(id));
    }
    
    function setAngularVelocity(omega) {
        return physics.body_setAngularVelocity(id, omega);
    }
    
    function getAngularVelocity() {
        return physics.body_getAngularVelocity(id);
    }
    
    function applyForce(force, point) {
        return physics.body_applyForce(id, force, point);
    }
    
    function applyTorque(torque) {
        return physics.body_applyTorque(id, torque);
    }
    
    function applyLinearImpulse(impulse, point) {
        return physics.body_applyLinearImpulse(id, impulse, point);
    }
    
    function applyAngularImpulse(impulse) {
        return physics.body_applyAngularImpulse(id, impulse);
    }
    
    function getMass() {
        return physics.body_getMass(id);
    }
    
    function setCenterOfMass(mass, center, inertia){
        return physics.body_setCenterOfMass(id, mass, center, inertia);
    }
    
    function getInertia() {
        return physics.body_getInertia(id);
    }
    
    function getWorldPoint(localPoint) {
        return emo.Vec2.fromArray(physics.body_getWorldPoint(id, localPoint));
    }
    
    function getWorldVector(localVector) {
        return emo.Vec2.fromArray(physics.body_getWorldVector(id, localVector));
    }
    
    function getLocalPoint(worldPoint) {
        return emo.Vec2.fromArray(physics.body_getLocalPoint(id, worldPoint));
    }
    
    function getLocalVector(worldVector) {
        return emo.Vec2.fromArray(physics.body_getLocalVector(id, worldVector));
    }
    
    function getLinearVelocityFromWorldPoint(worldPoint) {
        return emo.Vec2.fromArray(physics.body_getLinearVelocityFromWorldPoint(id, worldPoint));
    }
    
    function getLinearVelocityFromLocalPoint(localPoint) {
        return emo.Vec2.fromArray(physics.body_getLinearVelocityFromLocalPoint(id, localPoint));
    }
    
    function getLinearDamping() {
        return physics.body_getLinearDamping(id);
    }
    
    function setLinearDamping(linearDamping) {
        return physics.body_setLinearDamping(id, linearDamping);
    }
    
    function getAngularDamping() {
        return physics.body_getAngularDamping(id);
    }
    
    function setAngularDamping(angularDamping) {
        return physics.body_setAngularDamping(id, angularDamping);
    }
    
    function setType(bodyType) {
        return physics.body_setType(id, bodyType);
    }
    
    function getType() {
        return physics.body_getType(id);
    }
    
    function setBullet(flag) {
        return physics.body_setBullet(id, flag);
    }
    
    function isBullet() {
        return physics.body_isBullet(id);
    }
    
    function setSleepingAllowed(flag) {
        return physics.body_setSleepingAllowed(id, flag);
    }
    
    function isSleepingAllowed() {
        return physics.body_isSleepingAllowed(id);
    }
    
    function setAwake(flag) {
        return physics.body_setAwake(id, flag);
    }
    
    function isAwake() {
        return physics.body_isAwake(id);
    }
    
    function setActive(flag) {
        return physics.body_setActive(id, flag);
    }
    
    function isActive() {
        return physics.isActive(id);
    }
    
    function setFixedRotation(flag) {
        return physics.body_setFixedRotation(id, flag);
    }
    
    function isFixedRotation() {
        return physics.body_isFixedRotation(id);
    }
}

class emo.physics.BodyDef {
    type            = null;
    position        = null;
    angle           = null;
    linearVelocity  = null;
    angularVelocity = null;
    linearDamping   = null;
    angularDamping  = null;
    allowSleep      = null;
    awake           = null;
    fixedRotation   = null;
    bullet          = null;
    active          = null;
    inertiaScale    = null;
}

class emo.physics.Fixture {
    id     = null;
    bodyId = null;
    function constructor(_bodyId, _id) {
        bodyId = _bodyId;
        id     = _id;
    }
    function getBody() {
        return emo.physics.Body(bodyId);
    }
}

class emo.physics.FixtureDef {
    shape       = null;
    friction    = null;
    restitution = null;
    density     = null;
    isSensor    = null;
    filter      = null;
}

class emo.physics.Joint {
    id    = null;
    type = null;
    physics  = emo.Physics();
    function constructor(_id) {
        id = _id;
    }
    function getType() {
        return type;
    }
    function getAnchorA() {
        return emo.Vec2.fromArray(physics.joint_getAnchorA(id));
    }
    function getAnchorB() {
        return emo.Vec2.fromArray(physics.joint_getAnchorB(id));
    }
    function getReactionForce(inv_dt) {
        return emo.Vec2.fromArray(physics.joint_getReactionForce(id, inv_dt));
    }
    function getReactionTorque(inv_dt) {
        return emo.Vec2.fromArray(physics.joint_getReactionTorque(id, inv_dt));
    }
}
class emo.physics.DistanceJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_DISTANCE;
    }
    function setLength(length) {
        return physics.joint_setLength(id, length);
    }
    function getLength() {
        return physics.joint_getLength(id);
    }
    function setFrequency(hz) {
        return physics.joint_setFrequency(id, hz);
    }
    function getFrequency() {
        return physics.joint_getFrequency(id);
    }
    function setDampingRatio(ratio) {
        return physics.joint_setDampingRatio(id, ratio);
    }
    function getDampingRatio() {
        return physics.joint_getDampingRatio(id);
    }
}
class emo.physics.FrictionJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_FRICTION;
    }
    function setMaxForce(force) {
        return physics.joint_setMaxForce(id, force);
    }
    function getMaxForce() {
        return physics.joint_getMaxForce(id);
    }
    function setMaxTorque(torque) {
        return physics.joint_setMaxTorque(id, torque);
    }
    function getMaxTorque() {
        return physics.joint_getMaxTorque(id);
    }
}
class emo.physics.GearJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_GEAR;
    }
    function setRatio(ratio) {
        return physics.joint_setRatio(id, ratio);
    }
    function getRatio() {
        return physics.joint_getRatio(id);
    }
}
class emo.physics.LineJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_LINE;
    }
    function getJointTranslation() {
        return physics.joint_getJointTranslation(id);
    }
    function getJointSpeed() {
        return physics.joint_getJointSpeed(id);
    }
    function isLimitedEnabled() {
        return physics.joint_isLimitedEnabled(id);
    }
    function enableLimit(flag) {
        return physics.joint_enableLimit(id, flag);
    }
    function getLowerLimit() {
        return physics.joint_getLowerLimit(id);
    }
    function getUpperLimit() {
        return physics.joint_getUpperLimit(id);
    }
    function setLimits(lower, upper) {
        return physics.joint_setLimits(id, lower, upper);
    }
    function isMotorEnabled() {
        return physics.joint_isMotorEnabled(id);
    }
    function enableMotor(flag) {
        return physics.joint_enableMotor(id, flag);
    }
    function setMotorSpeed(speed) {
        return physics.joint_setMotorSpeed(id, speed);
    }
    function setMaxMotorForce(force) {
        return physics.joint_setMaxMotorForce(id, force);
    }
    function getMotorForce() {
        return physics.joint_getMotorForce(id);
    }
}
class emo.physics.PrismaticJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_PRISMATIC;
    }
    function getJointTranslation() {
        return physics.joint_getJointTranslation(id);
    }
    function getJointSpeed() {
        return physics.joint_getJointSpeed(id);
    }
    function isLimitedEnabled() {
        return physics.joint_isLimitedEnabled(id);
    }
    function enableLimit(flag) {
        return physics.joint_enableLimit(id, flag);
    }
    function getLowerLimit() {
        return physics.joint_getLowerLimit(id);
    }
    function getUpperLimit() {
        return physics.joint_getUpperLimit(id);
    }
    function setLimits(lower, upper) {
        return physics.joint_setLimits(id, lower, upper);
    }
    function isMotorEnabled() {
        return physics.joint_isMoterEnabled(id);
    }
    function enableMoter(flag) {
        return physics.joint_enableMoter(id, flag);
    }
    function setMotorSpeed(speed) {
        return physics.joint_setMotorSpeed(id, speed);
    }
    function setMaxMotorForce(force) {
        return physics.joint_setMaxMotorForce(id, force);
    }
    function getMotorForce() {
        return physics.joint_getMotorForce(id);
    }
}
class emo.physics.PulleyJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_PULLEY;
    }
    function getGroundAnchorA() {
        return emo.Vec2.fromArray(physics.joint_getGroundAnchorA(id));
    }
    function getGroundAnchorB() {
        return emo.Vec2.fromArray(physics.joint_getGroundAnchorB(id));
    }
    function getLength1() {
        return physics.joint_getLength1(id);
    }
    function getLength2() {
        return physics.joint_getLength2(id);
    }
    function getRatio() {
        return physics.joint_getRatio(id);
    }
}
class emo.physics.RevoluteJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_REVOLUTE;
    }
    function getJointAngle() {
        return physics.joint_getJointAngle(id);
    }
    function getJointSpeed() {
        return physics.joint_getJointSpeed(id);
    }
    function isLimitedEnabled() {
        return physics.joint_isLimitedEnabled(id);
    }
    function enableLimit(flag) {
        return physics.joint_enableLimit(id, flag);
    }
    function getLowerLimit() {
        return physics.joint_getLowerLimit(id);
    }
    function getUpperLimit() {
        return physics.joint_getUpperLimit(id);
    }
    function setLimits(lower, upper) {
        return physics.joint_setLimits(id, lower, upper);
    }
    function isMotorEnabled() {
        return physics.joint_isMoterEnabled(id);
    }
    function enableMoter(flag) {
        return physics.joint_enableMoter(id, flag);
    }
    function setMotorSpeed(speed) {
        return physics.joint_setMotorSpeed(id, speed);
    }
    function setMaxMotorTorque(torque) {
        return physics.joint_setMaxMotorTorque(id, torque);
    }
    function getMotorTorque() {
        return physics.joint_getMotorTorque(id);
    }
}
class emo.physics.WeldJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_WELD;
    }
}
class emo.physics.MouseJoint extends emo.physics.Joint {
    function constructor(_id) {
        id = _id;
        type = JOINT_TYPE_MOUSE;
    }
    function getTarget() {
        return physics.joint_getTarget(id);
    }
    function setTarget(target) {
        return physics.joint_setTarget(id, target);
    }
    function setMaxForce(force) {
        return physics.joint_setMaxForce(id, force);
    }
    function getMaxForce() {
        return physics.joint_getMaxForce(id);
    }
    function setFrequency(hz) {
        return physics.joint_setFrequency(id, hz);
    }
    function getFrequency() {
        return physics.joint_getFrequency(id);
    }
    function setDampingRatio(ratio) {
        return physics.joint_setDampingRatio(id, ratio);
    }
    function getDampingRatio() {
        return physics.joint_getDampingRatio(id);
    }
}
class emo.physics.JointDef {
    id       = null;
    type     = null;
    bodyA    = null;
    bodyB    = null;
    physics  = emo.Physics();
    collideConnected = null;
    function update() {
        return physics.updateJointDef(id, this);
    }
}

class emo.physics.DistanceJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_DISTANCE;
    frequencyHz  = null;
    dampingRatio = null;
    
    function constructor() {
        id = physics.newJointDef(type);
    }
    
    function initialize(bodyA, bodyB, anchorA, anchorB) {
        return physics.initDistanceJointDef(id, bodyA.id, bodyB.id, anchorA, anchorB);
    }
}
class emo.physics.FrictionJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_FRICTION;
    maxForce     = null;
    maxTorque    = null;
    function constructor() {
        id = physics.newJointDef(type);
    }
    function initialize(bodyA, bodyB, anchor) {
        return physics.initFrictionJointDef(id, bodyA.id, bodyB.id, anchor);
    }
}
class emo.physics.GearJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_GEAR;
    joint1 = null;
    joint2 = null;
    ratio  = null;
    function constructor() {
        id = physics.newJointDef(type);
    }
}
class emo.physics.LineJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_LINE;
    enableLimit  = null;
    lowerTranslation = null;
    upperTranslation = null;
    enableMotor   = null;
    maxMotorForce = null;
    motorSpeed    = null;
    function constructor() {
        id = physics.newJointDef(type);
    }
    function initialize(bodyA, bodyB, anchor, axis) {
        return physics.initLineJointDef(id, bodyA.id, bodyB.id, anchor, axis);
    }
}
class emo.physics.PrismaticJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_PRISMATIC;
    enableLimit    = null;
    lowerTranslation = null;
    upperTranslation = null;
    enableMotor   = null;
    maxMotorForce = null;
    motorSpeed    = null;
    function constructor() {
        id = physics.newJointDef(type);
    }
    function initialize(bodyA, bodyB, anchor, axis) {
        return physics.initPrismaticJointDef(id, bodyA.id, bodyB.id, anchor, axis);
    }
}
class emo.physics.PulleyJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_PULLEY;
    function constructor() {
        id = physics.newJointDef(type);
    }
    function initialize(bodyA, bodyB, groundAnchorA, groundAnchorB, anchorA, anchorB, ratio) {
        return physics.initPulleyJointDef(id, bodyA.id, bodyB.id,
            groundAnchorA, groundAnchorB, anchorA, anchorB, ratio);
    }
}
class emo.physics.RevoluteJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_REVOLUTE;
    enableLimit = null;
    lowerAngle  = null;
    upperAngle  = null;
    enableMotor = null;
    motorSpeed  = null;
    maxMotorTorque = null;
    function constructor() {
        id = physics.newJointDef(type);
    }
    function initialize(bodyA, bodyB, anchor) {
        return physics.initRevoluteJointDef(id, bodyA.id, bodyB.id, anchor);
    }
}
class emo.physics.WeldJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_WELD;
    function constructor() {
        id = physics.newJointDef(type);
    }
    function initialize(bodyA, bodyB, anchor) {
        return physics.initWeldJointDef(id, bodyA.id, bodyB.id, anchor);
    }
}
class emo.physics.MouseJointDef extends emo.physics.JointDef {
    type = JOINT_TYPE_MOUSE;
    target       = null;
    maxForce     = null;
    frequencyHz  = null;
    dampingRatio = null;

    function constructor() {
        id = physics.newJointDef(type);
    }
}
class emo.physics.PolygonShape {
    id      = null;
    physics = emo.Physics();
    type    = PHYSICS_SHAPE_TYPE_POLYGON;
    
    function constructor() {
        id = physics.newShape(PHYSICS_SHAPE_TYPE_POLYGON);
        id.type = "emo.physics.PolygonShape";
    }

    function set(vertices) {
        return physics.polygonShape_set(id, vertices);
    }
    
    function setAsBox(hx, hy, center = null, angle = null) {
        return physics.polygonShape_setAsBox(id, hx, hy, center, angle);
    }
    
    function setAsEdge(v1, v2) {
        return physics.polygonShape_setAsEdge(id, v1, v2);
    }
    
    function getVertex(idx) {
        return emo.Vec2.fromArray(physics.polygonShape_getVertex(id, idx));
    }
    
    function getVertexCount() {
        return physics.polygonShape_getVertexCount(id);
    }
    
    function radius(radius) {
        return physics.polygonShape_radius(id, radius);
    }
}

class emo.physics.CircleShape {
    id       = null;
    physics  = emo.Physics();
    type     = PHYSICS_SHAPE_TYPE_CIRCLE;
    function constructor() {
        id = physics.newShape(PHYSICS_SHAPE_TYPE_CIRCLE);
        id.type = "emo.physics.CircleShape";
    }

    function position(position) {
        return physics.circleShape_position(id, position);
    }
    
    function radius(radius) {
        return physics.circleShape_radius(id, radius);
    }
}

function emo::_onContact(...) {
    //state, _fixA, _fixB, _bodyA, _bodyB, _pos, _normal, normalImpulse, tangentImpulse
    local state = vargv[0];
    local fixtureA = emo.physics.Fixture(vargv[3], vargv[1]);
    local fixtureB = emo.physics.Fixture(vargv[4], vargv[2]);
    local position = emo.Vec2.fromArray(vargv[5]);
    local normal   = emo.Vec2.fromArray(vargv[6]);
    local normalImpulse  = vargv[7];
    local tangentImpulse = vargv[8];

    if (emo.rawin("onContact")) {
        emo.onContact(state, fixtureA, fixtureB, position, normal, normalImpulse, tangentImpulse);
    }
    if (EMO_RUNTIME_DELEGATE != null &&
             EMO_RUNTIME_DELEGATE.rawin("onContact")) {
        EMO_RUNTIME_DELEGATE.onContact(state, fixtureA, fixtureB, position, normal, normalImpulse, tangentImpulse);
    }
}

class emo.physics.PhysicsInfo {
    world   = null;
    fixture = null;
    sprite  = null;
    body    = null;
    type    = null;
    
    function constructor(_w, _s, _f, _type) {
        world   = _w;
        sprite  = _s;
        fixture = _f;
        body    = _f.getBody();
        type    = _type;
    }
    
    function update(timeStep, scale) {
        if (type != PHYSICS_BODY_TYPE_STATIC) {
            local pos = body.getPosition();
            
            local x = (pos.x * scale) - (sprite.getWidth()  * 0.5);
            local y = (pos.y * scale) - (sprite.getHeight() * 0.5);
            
            sprite.move(x, y);
            sprite.rotate(emo.toDegree(body.getAngle()));
        }
    }
    
    function getBody() {
        return body;
    }
    
    function getSprite() {
        return sprite;
    }
    
    function getType() {
        return type;
    }
    
    function getFixture() {
        return fixture;
    }
    
    function remove() {
        world.removePhysicsObject(this);
        world.destroyBody(getBody());
        
        world   = null;
        sprite  = null;
        fixture = null;
        body    = null;
        type    = null;
    }
}

class emo.physics.SoftPhysicsInfo extends emo.physics.PhysicsInfo {

    markers       = null;
    lines         = null;
    
    segments      = null;
    segmentJoints = null;
    innerJoints   = null;

    segmentCount  = null;    
    segmentPos    = null;
    texturePos    = null;
    
    texScale      = 1.0;
    
    function constructor(_world, _sprite, _fixture) {
        base.constructor(_world, _sprite, _fixture, PHYSICS_BODY_TYPE_DYNAMIC);
        
        markers  = [];
        lines    = [];
        
        segments      = [];
        segmentJoints = [];
        innerJoints   = [];
        
        segmentPos = [];
        texturePos = [];
        
        if (_sprite.rawin("getSegmentCount")) {
            segmentCount = _sprite.getSegmentCount().tofloat();
        }
        
        for (local i = 0; i < segmentCount; i++) {
            segmentPos.append(null);
            texturePos.append(null);
        }
    }

    function update(timeStep, scale) {
    
        if (sprite.rawin("updateTextureCoords")) {
            updateTexture(timeStep, scale);
        }
    
        base.update(timeStep, scale);
        
        for (local i = 0; i < markers.len(); i++) {
            local pos = segments[i].getPosition();
            
            local x = pos.x * scale;
            local y = pos.y * scale;
            
            markers[i].moveCenter(x, y);
            markers[i].rotate(emo.toDegree(segments[i].getAngle()));
        }
    }
    
    function updateTexture(timeStep, scale) {
    
        local centerPos = emo.Vec2(getBody().getPosition().x * scale,
                                   getBody().getPosition().y * scale);
    
        segmentPos[0] = emo.Vec2(0, 0);
        
        for (local i = 0; i < segmentCount - 2; i++) {
        
            local part = segments[i];
            local partPos = emo.Vec2(part.getPosition().x * scale, part.getPosition().y * scale);
   
            segmentPos[i + 1] = (partPos - centerPos) * emo.Vec2(texScale, texScale);
        }
        
        segmentPos[segmentCount - 1] = segmentPos[1];
    
        for (local i = 0; i < segmentCount; i++) {
            segmentPos[i] = centerPos + segmentPos[i];
        }
    
        local baseAngle = PI;
        local angle     = 0;
     
        texturePos[0] = emo.Vec2(0, 0);
        
        for (local i = 0; i < segmentCount - 2; i++) {
            angle = baseAngle + (2 * PI / (segmentCount - 2) * i);
            texturePos[i + 1] = emo.Vec2(sin(angle), cos(angle));
        }
        texturePos[segmentCount - 1] = texturePos[1];
    
        local textureCenter = emo.Vec2(0.5, 0.5);
        for (local i = 0; i < segmentCount; i++) {
            texturePos[i] = (texturePos[i] * emo.Vec2(0.5, 0.5)) + textureCenter;
        }
        
        sprite.updateTextureCoords(texturePos);
        sprite.updateSegmentCoords(segmentPos);
        
        for (local i = 0; i < segmentCount; i++) {
            if (lines.len() == 0) break;
            if (i == 0) {
                lines[0].move(
                    segmentPos[i].x, segmentPos[i].y,
                    segmentPos[segmentPos.len()-1].x, segmentPos[segmentPos.len()-1].y);
            } else {
                lines[i].move(
                segmentPos[i-1].x, segmentPos[i-1].y,
                segmentPos[i].x,   segmentPos[i].y);
            }
        }
    }
    
    function remove() {
        foreach (line in lines) {
            line.remove();
        }
        foreach (marker in markers) {
            marker.remove();
        }
        foreach (segment in segments) {
            world.destroyBody(segment);
        }
        foreach (joint in segmentJoints) {
            world.destroyJoint(joint);
        }
        foreach (joint in innerJoints) {
            world.destroyJoint(joint);
        }
        base.remove();
    }
}

function emo::Physics::createSoftCircleSprite(world, sprite, fixtureDef = null, debug = false) {
    local segmentCount = sprite.rawin("getSegmentCount") ? sprite.getSegmentCount() - 2 : 16;
    
    local scale  = world.scale.tofloat();
    local radius = sprite.getWidth() / 2.0 / scale;
    local angleStep = (PI * 2.0) / segmentCount; 
    local sinHalfAngle = sin(angleStep * 0.5);
    local subCircleRadius = sinHalfAngle * radius / (1.0 + sinHalfAngle); 
     
    local vecOffset = emo.Vec2(radius - subCircleRadius, radius - subCircleRadius);

    if (fixtureDef == null) {
        fixtureDef = emo.physics.FixtureDef();
        fixtureDef.density     = 0.1; 
        fixtureDef.restitution = 0.05;
        fixtureDef.friction    = 1.0;
    }
    fixtureDef.shape = emo.physics.CircleShape();
    fixtureDef.shape.radius(subCircleRadius);
    
    local innerBodyPos = emo.Vec2(
                sprite.getCenterX() / scale,
                sprite.getCenterY() / scale);
    
    local angle    = 0;
    local markers  = [];
    local lines    = [];
    local segments = [];
    
    for (local i = 0; i < segmentCount; i++) {
            
        local offset = emo.Vec2(sin(angle), cos(angle));
        offset = offset * vecOffset;
        offset = offset + innerBodyPos;
        angle += angleStep;

        local bodyDef = emo.physics.BodyDef();
        bodyDef.type  = PHYSICS_BODY_TYPE_DYNAMIC;
        bodyDef.position = offset;
        
        local segment = world.createBody(bodyDef);
        segment.createFixture(fixtureDef);
            
        segments.append(segment);
        
        if (debug) {
            local marker = emo.Rectangle();
            marker.color(1, 0, 0, 1);
            marker.setSize(subCircleRadius * scale * 2.0, subCircleRadius * scale * 2.0);
            marker.setZ(sprite.getZ() + 1);
            marker.moveCenter(offset.x * scale, offset.y * scale);
            marker.load();
            markers.append(marker);
        }
    }
    
    if (debug) {
        for (local i = 0; i < segmentCount + 2; i++) {
           local line = emo.Line();
           line.setZ(sprite.getZ() + 1);
           line.setWidth(2);
           line.load();
            
           lines.append(line);
        }
    }
    
    local bodyDef = emo.physics.BodyDef();
    bodyDef.type  = PHYSICS_BODY_TYPE_DYNAMIC;
    bodyDef.position = innerBodyPos;
    
    fixtureDef.shape.radius((radius - subCircleRadius * 2.0) * 0.5);
    
    local innerBody = world.createBody(bodyDef);
    local fixture = innerBody.createFixture(fixtureDef);

    local partToCentDist = segments[0].getPosition().distance(innerBody.getPosition());
    local partToOffset = emo.Vec2(sin(0), cos(0));
    partToOffset = partToOffset * emo.Vec2(radius, radius);
    local partEdgePos = innerBodyPos + partToOffset;
    local partEdgeToCentDist = partEdgePos.distance(innerBody.getPosition());
    local texScale = partEdgeToCentDist / partToCentDist;

    local segmentJoints = [];
    local innerJoints   = [];
    local jointDef = emo.physics.DistanceJointDef();
    
    for (local i = 0; i < segmentCount; i++) {
        local neighborIndex = (i + 1) % segmentCount;
        
        // joints between outer circles
        jointDef.initialize(segments[i], segments[neighborIndex],
                                segments[i].getWorldCenter(), 
                                segments[neighborIndex].getWorldCenter());
        jointDef.collideConnected = true;
        jointDef.frequencyHz = 10.0;
        jointDef.dampingRatio = 0.5;
        
        segmentJoints.append(world.createJoint(jointDef));
        
        // create joints - outer circles with inner circle
        jointDef.initialize(segments[i], innerBody, segments[i].getWorldCenter(), innerBodyPos);
        jointDef.collideConnected = true;
        jointDef.frequencyHz = 10.0;
        jointDef.dampingRatio = 0.5;
            
        innerJoints.append(world.createJoint(jointDef));
    }
    
    local physicsInfo = emo.physics.SoftPhysicsInfo(world, sprite, fixture);
    physicsInfo.markers  = markers;
    physicsInfo.lines    = lines;
    physicsInfo.segments = segments;
    physicsInfo.texScale = texScale;
    
    world.addPhysicsObject(physicsInfo);
    sprite.setPhysicsInfo(physicsInfo);
    
    physicsInfo.update(0, scale);
    
    return physicsInfo;
}

function emo::Physics::createSprite(world, sprite, bodyType, shape, fixtureDef = null, bodyDef = null) {

    local halfWidth  = sprite.getWidth()  * 0.5;
    local halfHeight = sprite.getHeight() * 0.5;
    local scale = world.scale.tofloat();

    if (bodyDef == null) {
        bodyDef = emo.physics.BodyDef();
    }
    bodyDef.type = bodyType;
    bodyDef.position = emo.Vec2(
            (sprite.getX() + halfWidth)  / scale,
            (sprite.getY() + halfHeight) / scale
    );
    bodyDef.angle = emo.toRadian(sprite.getAngle());
    
    local body = world.createBody(bodyDef);
    
    if (shape.type == PHYSICS_SHAPE_TYPE_POLYGON) {
        shape.setAsBox(halfWidth / scale, halfHeight / scale);
    }
    
    if (fixtureDef == null) fixtureDef = emo.physics.FixtureDef();
    fixtureDef.shape = shape;

    local fixture = body.createFixture(fixtureDef);
    local physicsInfo = emo.physics.PhysicsInfo(world, sprite, fixture, bodyType);
    
    world.addPhysicsObject(physicsInfo);
    sprite.setPhysicsInfo(physicsInfo);
    
    return physicsInfo;
}

function emo::Physics::createStaticSprite(world, sprite, fixtureDef = null, bodyDef = null) {
    local shape = emo.physics.PolygonShape();
    return emo.Physics.createSprite(world, sprite, PHYSICS_BODY_TYPE_STATIC, shape, fixtureDef, bodyDef);
}

function emo::Physics::createDynamicSprite(world, sprite, fixtureDef = null, bodyDef = null) {
    local shape = emo.physics.PolygonShape();
    return emo.Physics.createSprite(world, sprite, PHYSICS_BODY_TYPE_DYNAMIC, shape, fixtureDef, bodyDef);
}

function emo::Physics::createKinematicSprite(world, sprite, fixtureDef = null, bodyDef = null) {
    local shape = emo.physics.PolygonShape();
    return emo.Physics.createSprite(world, sprite, PHYSICS_BODY_TYPE_KINEMATIC, shape, fixtureDef, bodyDef);
}

function emo::Physics::createStaticCircleSprite(world, sprite, radius, fixtureDef = null, bodyDef = null) {
    local shape = emo.physics.CircleShape();
    shape.radius(radius / world.scale.tofloat());
    return emo.Physics.createSprite(world, sprite, PHYSICS_BODY_TYPE_STATIC, shape, fixtureDef, bodyDef);
}

function emo::Physics::createDynamicCircleSprite(world, sprite, radius, fixtureDef = null, bodyDef = null) {
    local shape = emo.physics.CircleShape();
    shape.radius(radius / world.scale.tofloat());
    return emo.Physics.createSprite(world, sprite, PHYSICS_BODY_TYPE_DYNAMIC, shape, fixtureDef, bodyDef);
}

