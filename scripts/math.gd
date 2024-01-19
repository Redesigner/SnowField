class_name Math

static func angle_between(angle1:float, angle2:float):
	if (angle1 > 360.0 || angle1 < 0.0):
		angle1 = wrapf(angle1, 0.0, 360.0)
		
	if (angle2 > 360.0 || angle2 < 0.0):
		angle2 = wrapf(angle2, 0.0, 360.0)

	var delta_angle:float = angle2 - angle1
	if (delta_angle > 180.0):
		delta_angle -= 360.0
	elif (delta_angle < -180.0):
		delta_angle += 360.0

	return delta_angle

static func angle_interp_to_constant(angle:float, destination_angle:float, rate:float):
	var delta_angle:float = angle_between(angle, destination_angle)
	delta_angle = clamp(delta_angle, -rate, rate)
	return angle + delta_angle
