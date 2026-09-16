local _, TRB = ...

-- World of Warcraft: Forever saved-variable migrations. There is no settings history yet, so no hook is
-- defined: Core's TRB.Functions.Settings:PortForwardSettings does nothing and manualUpdateChecks starts
-- empty. When the first settings-shape change ships, add TRB.Flavor.PortForwardSettings here (and, for
-- one-shot per-class checks, TRB.Flavor.DefaultManualUpdateChecks / RunManualUpdateChecks) following
-- Flavors\Mainline\Migrations.lua; every step must be idempotent because it runs on every login.
