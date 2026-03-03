#ifndef slic3r_SlicingPlane_hpp_
#define slic3r_SlicingPlane_hpp_

#include <cmath>

namespace Slic3r {

class SlicingPlane
{
public:
    explicit SlicingPlane(double slice_angle_deg = 0.)
        : m_angle_deg(slice_angle_deg)
        , m_angle_rad(slice_angle_deg * M_PI / 180.)
        , m_angle_cos(std::cos(m_angle_rad))
    {}

    bool is_horizontal() const { return std::abs(m_angle_deg) < 1e-9; }
    double angle_deg() const { return m_angle_deg; }
    double angle_cos() const { return m_angle_cos; }

    // Project distance along the slicing-plane normal to machine Z at y = 0.
    double to_machine_z(double normal_distance) const {
        return is_horizontal() ? normal_distance : normal_distance / m_angle_cos;
    }

private:
    double m_angle_deg;
    double m_angle_rad;
    double m_angle_cos;
};

}

#endif
