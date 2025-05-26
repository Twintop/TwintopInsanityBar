---@diagnostic disable: inject-field, duplicate-set-field

local MAJOR = "LibSmoothMove-1.0"
local MINOR = 0

local lib, upgrade = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

lib.frame     = lib.frame     or CreateFrame('Frame')
lib.smoothing = lib.smoothing or {}

-------------------------------------------------------------------------------

local abs = math.abs

local function AnimationTick()
	for frame, value in pairs(lib.smoothing) do
		local newX = value.currentOffsetX + ((value.offsetX - value.currentOffsetX) / 3)
		local newY = value.currentOffsetY + ((value.offsetY - value.currentOffsetY) / 3)

		if abs(newX - value.currentOffsetX) < 2 and abs(newY - value.currentOffsetY) < 2 then
			frame:SetPoint_(value.point, value.relativeTo, value.relativePoint, value.offsetX, value.offsetY)
			lib.smoothing[frame] = nil
		else
			lib.smoothing[frame].currentOffsetX = newX
			lib.smoothing[frame].currentOffsetY = newY
			frame:SetPoint_(value.point, value.relativeTo, value.relativePoint, newX, newY)
		end
	end
end

lib.frame:SetScript("OnUpdate", AnimationTick)

local function SmoothSetPoint(self, point, relativeTo, relativePoint, offsetX, offsetY)
	local _point, _relativeTo, _relativePoint, _offsetX, _offsetY = self:GetPoint()

	-- Only do smooth movement if the relative points remain the same.
	if point ~= _point or relativeTo ~= _relativeTo or relativePoint ~= _relativePoint then
		lib.smoothing[self] = nil
		self:SetPoint_(point, relativeTo, relativePoint, offsetX, offsetY)
	elseif offsetX == _offsetX and offsetY == _offsetY then
		lib.smoothing[self] = nil
		self:SetPoint_(point, relativeTo, relativePoint, offsetX, offsetY)
	else
		lib.smoothing[self] = {
			point = point,
			relativeTo = relativeTo,
			relativePoint = relativePoint,
			offsetX = offsetX,
			offsetY = offsetY,
			currentOffsetX = _offsetX,
			currentOffsetY = _offsetY
		}
	end
end

if upgrade then
	for bar, value in pairs(lib.smoothing) do
		if bar.SetPoint_ then
			bar.SetPoint = SmoothSetPoint
		end
	end
end

function lib:SmoothMove(frame)
	if not frame.SetPoint_ then
		frame.SetPoint_ = frame.SetPoint;
		frame.SetPoint = SmoothSetPoint;
	end
end

function lib:Reset(frame)
	if frame.SetPoint_ then
		frame.SetPoint = frame.SetPoint_;
		frame.SetPoint_ = nil;
	end
end