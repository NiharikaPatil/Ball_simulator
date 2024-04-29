// main.rs

//use std::os::raw::c_char;
use std::ffi::{CString, CStr};

#[repr(C)]
pub struct Ball {
    x: f64,
    y: f64,
    dx: f64,
    dy: f64,
}

#[no_mangle]
pub extern "C" fn move_balls(balls: *mut Ball, count: usize, width: f64, height: f64) {
    unsafe {
        let balls_slice = std::slice::from_raw_parts_mut(balls, count);
        for ball in balls_slice.iter_mut() {
            ball.x += ball.dx;
            ball.y += ball.dy;

            if ball.x <= 0.0 || ball.x >= width {
                ball.dx = -ball.dx;
            }

            if ball.y <= 0.0 || ball.y >= height {
                ball.dy = -ball.dy;
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn create_balls(count: usize) -> *mut Ball {
    let mut balls = Vec::with_capacity(count);
    for _ in 0..count {
        balls.push(Ball {
            x: rand::random::<f64>() * 400.0,
            y: rand::random::<f64>() * 400.0,
            dx: (rand::random::<f64>() * 4.0) - 2.0,
            dy: (rand::random::<f64>() * 4.0) - 2.0,
        });
    }
    let mut boxed_balls = balls.into_boxed_slice();
    let ptr = boxed_balls.as_mut_ptr();
    std::mem::forget(boxed_balls);
    ptr
}

#[no_mangle]
pub extern "C" fn free_balls(ptr: *mut Ball) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        let _ = Box::from_raw(ptr);
    }
}

#[no_mangle]
pub extern "C" fn get_ball(ptr: *const Ball, index: usize) -> *const Ball {
    unsafe {
        ptr.offset(index as isize)
    }
}

#[no_mangle]
pub extern "C" fn get_ball_count(ptr: *const Ball) -> usize {
    unsafe {
        1 + ptr as usize
    }
}

