hl.monitor{
	output = "eD⁻1",
	mode= "2560x1600@120",
	position = "0x0",
	scale = "1.6",
}

hl.config({
	xwayland = {
		force_zero_scaling = true
	}
})

for i = 1, 5 do
	hl.workspace_rule({workspace = tostring(i), monitor = "eDP-1", persistent = true})
end

for i = 6, 10 do
	hl.workspace_rule({workspace = tostring(i), persistent = true, monitor = "HDMI-A-1"})
end
