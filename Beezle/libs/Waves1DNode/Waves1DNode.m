//
//  Waves1DNode.m
//  Waves1D
//
//  Created by Scott Lembcke on 12/10/11.
//  Copyright Howling Moon Software 2011. All rights reserved.
//


#import "Waves1DNode.h"

@implementation Waves1DNode

@synthesize color = _color;

-(id)initWithBounds:(CGRect)bounds count:(int)count damping:(float)damping diffusion:(float)diffusion;
{
	if((self = [super init])){
		_bounds = bounds;
		_count = count;
		_damping = damping;
		_diffusion = diffusion;
        
        _color = ccc4f(1.0f, 1.0f, 1.0f, 1.0f);
		
		_h1 = calloc(_count, sizeof(float));
		_h2 = calloc(_count, sizeof(float));
        
        shader_ = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_Position_uColor];
        colorLocation_ = glGetUniformLocation(shader_->program_, "u_color");
	}
	
	return self;
}

- (void) dealloc
{
	free(_h1);
	free(_h2);
	
	[super dealloc];
}


-(void)vertlet {
	for(int i=0; i<_count; i++) _h1[i] = 2.0*_h2[i] - _h1[i];
	
	float *temp = _h2;
	_h2 = _h1;
	_h1 = temp;
}

static inline float
diffuse(float diff, float damp, float prev, float curr, float next){
	return (curr*diff + ((prev + next)*0.5f)*(1.0f - diff))*damp;
}

-(void)diffuse {
	float prev = _h2[0];
	float curr = _h2[0];
	float next = _h2[1];

	_h2[0] = diffuse(_diffusion, _damping, prev, curr, next);

	for(int i=1; i<(_count - 1); ++i){
		prev = curr;
		curr = next;
		next = _h2[i + 1];

		_h2[i] = diffuse(_diffusion, _damping, prev, curr, next);
	}
	
	prev = curr;
	curr = next;
	_h2[_count - 1] = diffuse(_diffusion, _damping, prev, curr, next);
}

-(float)dx{return _bounds.size.width/(GLfloat)(_count - 1);}

- (void)draw {
    
    // It would be better to run these on a fixed timestep.
	// As an GFX only effect it doesn't really matter though.
	[self vertlet];
	[self diffuse];
    
	GLfloat dx = [self dx];
	GLfloat top = _bounds.size.height;
    
	// Build a vertex array and render it.
	struct Vertex{GLfloat x,y;};
	struct Vertex verts[_count*2];
	for(int i=0; i<_count; i++){
		GLfloat x = i*dx;
		verts[2*i + 0] = (struct Vertex){x, 0};
		verts[2*i + 1] = (struct Vertex){x, top + _h2[i]};
	}
	
    [shader_ use];
    [shader_ setUniformForModelViewProjectionMatrix];
    [shader_ setUniformLocation:colorLocation_ with4fv:(GLfloat*) &_color.r count:1];
	
	[[CCDirector sharedDirector] setGLDefaultValues];
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, verts);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei) _count*2);
}

-(void) makeSplashAt:(float)x amount:(float)amount
{
	// Changing the values of heightfield in h2 will make the waves move.
	// Here I only change one column, but you get the idea.
	// Change a bunch of the heights using a nice smoothing function for a better effect.
	
	int index = MAX(0, MIN((int)(x/[self dx]), _count - 1));
	_h2[index] += amount;
}

@end

/**
-Ideas to make it better:
 * Add clamping to avoid giant, crappy looking waves.
 * Make it run on a fixed timestep.
 * Add texturing to give the surface a nice (and anti-aliased) look.
 * Fancier makeSplash method that does more than a single point.
*/