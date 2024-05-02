// Rust - lib.rs
use rand::Rng;
use std::mem;
use std::slice;
use std::os::raw::{c_double, c_int};

#[repr(C)]
pub struct Ball {
    x: f64,
    y: f64,
    dx: f64,
    dy: f64,
    color_index: i32,
}

#[repr(C)]
pub struct Balls {
    ptr: *mut Ball,
    count: usize,
}

#[no_mangle]
pub extern "C" fn create_balls(count: usize, color_count: i32) -> *mut Balls {
    println!("In create balls");
    let mut balls = Vec::with_capacity(count);
    let mut rng = rand::thread_rng();
    for _ in 0..count {
        let color_index = rng.gen_range(0..color_count) as i32;
        println!("In create balls");
        balls.push(Ball {
            x: rng.gen::<f64>() * 2280.0,
            y: rng.gen::<f64>() * 530.0,
            dx: (rng.gen::<f64>() * 4.0) - 2.0,
            dy: (rng.gen::<f64>() * 4.0) - 2.0,
            color_index,
        });
        

    }
    let mut balls_box = balls.into_boxed_slice();
    let balls_ptr = balls_box.as_mut_ptr();
    mem::forget(balls_box);

    let balls_data = Box::new(Balls { ptr: balls_ptr, count: count });
    Box::into_raw(balls_data)
}

#[no_mangle]
pub extern "C" fn move_balls(balls: *mut Balls, width: f64, height: f64) {
    unsafe {
        if balls.is_null() {
            return;
        }

        let balls_struct = &mut *balls;
        let balls_slice = slice::from_raw_parts_mut(balls_struct.ptr, balls_struct.count);

        // Move each ball and check boundaries
        for i in 0..balls_slice.len() {
            let ball = &mut balls_slice[i];
            ball.x += ball.dx;
            ball.y += ball.dy;

            // Boundary conditions
            if ball.x <= 10.0 || ball.x >= width - 10.0 {
                ball.dx = -ball.dx;
            }
            if ball.y <= 10.0 || ball.y >= height - 10.0 {
                ball.dy = -ball.dy;
            }
        }

        // Collision detection and response using indices
        for i in 0..balls_slice.len() {
            for j in i + 1..balls_slice.len() {
                let (dx, dy) = {
                    let ball = &balls_slice[i];
                    let other = &balls_slice[j];
                    ((ball.x - other.x), (ball.y - other.y))
                };
                let distance = (dx.powi(2) + dy.powi(2)).sqrt();

                if distance <= 10.0 {  // Assuming each ball has a radius of 5
                    let (ball, other) = balls_slice.split_at_mut(j);
                    std::mem::swap(&mut ball[i].dx, &mut other[0].dx);
                    std::mem::swap(&mut ball[i].dy, &mut other[0].dy);
                }
            }
        }
    }
    println!("Move function completed");
}


#[no_mangle]
pub extern "C" fn free_balls(balls: *mut Balls) {
    println!("In free balls function");
    unsafe {
        if !balls.is_null() {
            let balls_struct = Box::from_raw(balls);
            let balls_vec = Box::from_raw(slice::from_raw_parts_mut(balls_struct.ptr, balls_struct.count));
            drop(balls_vec);
        }
    }
}


